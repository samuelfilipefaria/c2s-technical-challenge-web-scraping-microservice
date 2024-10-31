class ScrapeDataFromWebMotorsJob
  include Sidekiq::Job
  sidekiq_options retry: 0

  sidekiq_retries_exhausted do |job, ex|
    token = job['args'][1]
    web_scraping_task_id = job['args'][2]

    HTTParty.put(
      "http://main_task_system_api:3000/web_scraping_tasks/update",
        body: {
          token: token,
          web_scraping_task_id: web_scraping_task_id,
          state: "failed",
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    HTTParty.post(
      "http://notification_microservice_api:2000/create_web_scraping_notification",
      body: {
        token: token,
        scraped_data: "",
        result: "failed",
        web_scraping_task_id: web_scraping_task_id
      }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )
  end

  def perform(url, token, web_scraping_task_id)
    headless = Headless.new
    headless.start

    browser = Watir::Browser.new :firefox, headless: true
    browser.goto(url)

    html_doc = browser.element(css: ".Detail__container").wait_until(timeout: 300, message: "Oops, a problem occurred") { |el| el.present? }
    car_brand_and_model_html = Nokogiri::HTML5(html_doc.inner_html).at_css(".VehicleDetails__header__title")
    car_price_html = Nokogiri::HTML5(html_doc.inner_html).at_css(".Forms__vehicleSendProposal__container__price")

    car_brand = car_brand_and_model_html.inner_text.split(" ")[0]
    car_model = car_brand_and_model_html.first_element_child.inner_html
    car_price = car_price_html.inner_text.split(" ")[1]
    car_price.gsub!(".", "")
    car_price = car_price.to_f

    headless.destroy

    if (car_brand && car_model && car_price)
      WebMotorsScrapedData.create(
        brand: car_brand,
        model: car_model,
        price: car_price,
        web_scraping_task_id: web_scraping_task_id
      )
      
      HTTParty.put(
      "http://main_task_system_api:3000/web_scraping_tasks/update",
        body: {
          token: token,
          web_scraping_task_id: web_scraping_task_id,
          state: "completed",
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

      HTTParty.post(
        "http://notification_microservice_api:2000/create_web_scraping_notification",
        body: {
          token: token,
          scraped_data: "Brand: #{car_brand} | Model: #{car_model} | Price: R$ #{car_price}",
          result: "success",
          web_scraping_task_id: web_scraping_task_id
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
    end
  end
end
