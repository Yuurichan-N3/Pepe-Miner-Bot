require 'httparty'
require 'colorize'
require 'json'

# URL endpoints
LOGIN_URL = "https://fission-api.hivehubs.app/api/login/tg"
SCENE_URL = "https://fission-api.hivehubs.app/api/scene/sync/scene"

# Headers
HEADERS = {
  "accept" => "application/json, text/plain, */*",
  "content-type" => "application/json",
  "origin" => "https://pepe.hivehubs.app",
  "referer" => "https://pepe.hivehubs.app/",
  "sec-ch-ua" => '"Microsoft Edge WebView2";v="135", "Chromium";v="135", "Not-A.Brand";v="8", "Microsoft Edge";v="135"',
  "sec-ch-ua-mobile" => "?0",
  "sec-ch-ua-platform" => '"Windows"',
  "user-agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36 Edg/135.0.0.0"
}

# Function to display banner
def print_banner
  banner = <<-BANNER
  ╔══════════════════════════════════════════════╗
  ║             🌟 PEPE MINER BOT                ║
  ║   Automate your Pepe scene sync claim!       ║
  ║  Developed by: https://t.me/sentineldiscus   ║
  ╚══════════════════════════════════════════════╝
  BANNER
  puts banner.blue
end

# Function to read init_data from data.txt
def read_init_data
  begin
    File.exist?("data.txt") ? File.readlines("data.txt").map(&:strip).reject(&:empty?) : []
  rescue StandardError => e
    puts "Error membaca data.txt: #{e.message}".red
    []
  end
end

# Function to get token from init_data or refresh
def get_token(account)
  init_data = account[:init_data]
  refresh = account[:refresh]

  if refresh && account[:refresh_end_at].to_i > Time.now.to_i
    payload = {
      refresh: refresh,
      product_id: 1,
      lang: "en"
    }
    log_prefix = "refresh #{refresh[0,10]}..."
  else
    return nil unless init_data
    payload = {
      init_data: init_data,
      referrer: "",
      product_id: 1,
      lang: "en"
    }
    log_prefix = "init_data #{init_data[0,20]}..."
  end

  begin
    response = HTTParty.post(LOGIN_URL, headers: HEADERS, body: payload.to_json)
    if response.code == 200
      data = JSON.parse(response.body)
      if data["code"] == 0 && data["data"] && data["data"]["token"]
        token_data = data["data"]["token"]
        account.merge!(
          token: token_data["token"],
          token_end_at: token_data["token_end_at"],
          refresh: token_data["refresh"],
          refresh_end_at: token_data["refresh_end_at"]
        )
        puts "Berhasil mendapatkan token untuk #{log_prefix}".green
        return account[:token]
      else
        puts "Gagal mendapatkan token untuk #{log_prefix} - #{data['message'] || 'Error tidak diketahui'}".red
        return nil
      end
    else
      puts "Gagal mendapatkan token untuk #{log_prefix} - Status #{response.code}".red
      return nil
    end
  rescue StandardError => e
    puts "Error saat mendapatkan token untuk #{log_prefix} - #{e.message}".red
    return nil
  end
end

# Function to send scene request
def send_scene_request(token, scene_type)
  payload = {
    token: token,
    scene_type: scene_type,
    product_id: 1,
    lang: "en"
  }

  begin
    response = HTTParty.post(SCENE_URL, headers: HEADERS, body: payload.to_json)
    if response.code == 200
      data = JSON.parse(response.body)
      if data["code"] == 0 && data["data"] && !data["data"].empty?
        puts "Scene_type #{scene_type}: Berhasil".green
        return true
      else
        error_message = data["message"] || "Invalid scene_type atau data kosong"
        puts "Scene_type #{scene_type}: Gagal - #{error_message}".red
        return false
      end
    else
      puts "Scene_type #{scene_type}: Gagal - Status #{response.code}".red
      return false
    end
  rescue StandardError => e
    puts "Scene_type #{scene_type}: Error - #{e.message}".red
    return false
  end
end

# Main program
def main
  # Display banner
  print_banner

  # Read init_data from data.txt
  init_data_list = read_init_data
  if init_data_list.empty?
    puts "Tidak ada init_data di data.txt atau file tidak ditemukan.".red
    return
  end

  # Initialize accounts
  accounts = init_data_list.map { |init_data| { init_data: init_data } }

  loop do
    # Process each account
    accounts.each do |account|
      init_data = account[:init_data]
      puts "\nMemproses akun dengan init_data: #{init_data[0,20]}...".yellow

      # Get token at the start of processing this account
      token = get_token(account)
      if token.nil?
        puts "Melewati akun dengan init_data: #{init_data[0,20]}... karena gagal mendapatkan token.".red
        next
      end

      # Loop for scene_type from 0 to 19
      (0..19).each do |scene_type|
        success = send_scene_request(token, scene_type)
        unless success
          puts "Request gagal pada scene_type #{scene_type}, menghentikan loop untuk akun ini.".red
          break
        end
        # Wait 3 seconds between requests
        puts "Menunggu 3 detik sebelum request berikutnya...".yellow
        sleep(3)
      end
    end

    # Wait 4 hours before processing all accounts again
    puts "\nMenunggu 4 jam sebelum memproses semua akun lagi...".blue
    sleep(4 * 3600)
  end
end

# Run the program
main if __FILE__ == $PROGRAM_NAME
