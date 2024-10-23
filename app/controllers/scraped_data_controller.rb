class ScrapedDataController < ActionController::API
  before_action :authorize_user, except: :api_message
  
  def send_response(message, code)
    render json: {APIresponse: message}, status: code
  end

  def api_message
    send_response("Hello! This is the microservice for WEB SCRAPING", 200)
  end

  def is_given_token_valid(given_token)
    authentication_microservice_response = HTTParty.get("http://authentication_microservice_api:5000/users/valid_token?token=#{given_token}")
    authentication_microservice_response.code == 200
  end

  def authorize_user
    send_response("Token is invalid! User not found!", 404) unless is_given_token_valid(params[:token])
  end

  def scrape_data
    new_scraping = DataScraping.new(
      scraped_data: "",
      task_id: params[:task_id],
      url_for_scraping: params[:url_for_scraping],
    )

    if new_scraping.save
      send_response("Data scraped!", 201)

      task = HTTParty.get('http://main_task_system_api:3000/tasks/get_a_task', body: {
        token: params[:token],
        id: params[:task_id],
      }.to_json, headers: { 'Content-Type' => 'application/json' })

      HTTParty.put('http://main_task_system_api:3000/tasks/edit', body: {
        id: params[:task_id],
        token: params[:token],
        description: task["description"],
        task_type: "Web Scraping",
        state: "finished",
        url_for_scraping: params[:url_for_scraping],
      }.to_json, headers: { 'Content-Type' => 'application/json' })

      
      HTTParty.post('http://notification_microservice_api:2000/send_notification', body: {
        token: params[:token],
        task_description: task["description"],
        operation: "finished",
        task_id: task["id"],
        scraped_data: "aqui ficarão os dados",
      }.to_json, headers: { 'Content-Type' => 'application/json' })
    else
      send_response("Error creating task!", 500)
    end
  end
end
