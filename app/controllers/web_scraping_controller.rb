require "./app/sidekiq/scrape_data_from_web_motors_job.rb"

class WebScrapingController < ActionController::API
  before_action :authorize_user

  def send_response(message, code)
    render json: {APIresponse: message}, status: code
  end

  def is_given_token_valid(given_token)
    authentication_microservice_response = HTTParty.get("http://authentication_microservice_api:5000/users/get_data?token=#{given_token}")
    authentication_microservice_response.code == 200
  end

  def authorize_user
    send_response("Token is invalid! User not found!", 404) unless is_given_token_valid(params[:token])
  end

  def web_motors
    HTTParty.put(
      "http://main_task_system_api:3000/web_scraping_tasks/update",
      body: {
        token: params[:token],
        web_scraping_task_id: params[:web_scraping_task_id],
        state: "in progress",
      }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )

    ScrapeDataFromWebMotorsJob.perform_async(params[:url_for_scraping], params[:token], params[:web_scraping_task_id])
    send_response("Scraping data...", 200)
  end
end
