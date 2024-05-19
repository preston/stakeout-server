# require 'capybara'
# require 'capybara/poltergeist'
require 'thread'

class Service < ApplicationRecord
  include PgSearch::Model
  # pg_search_scope :search_by_name_or_description, against: %i[name description], using: {
  pg_search_scope :search_by_name, against: %i[name], using: {
    #    trigram: {},
    tsearch: { prefix: true } # Partial words
  }

  belongs_to :dashboard, touch: true
  validates_presence_of :dashboard

  # validates_presence_of :dashboard
  validates_presence_of :name
  validates_presence_of :host

  # REFACTOR Nasty that this is a singleton, but it leaks a phantomjs process on #visit :(
  # https://github.com/jonleighton/poltergeist/issues/348
  # BROWSER = Capybara::Session.new(:poltergeist)
  # BROWSER_LOCK = Mutex.new
  # BROWSER = nil
  # Puppeteer.launch(headless: false, slow_mo: 50, args: ['--window-size=1280,800']) do |browser|
  # BROWSER = broswer
  #   end

  def expire_check
    self.checked_at = nil
    self.http_screenshot = nil
    save
  end

  def check_if_older_than(date)
    last = checked_at
    if last.nil? || last < date
      puts "Checking service #{name}."
      check
    else
      puts "Skipping service check for #{name}."
    end
  end

  def check_is_needed
    checked_at.nil? || checked_at < 1.minute.ago
  end

  #   def check_if_needed
  #     if !checked_is_needed
  # puts "Service #{self.name} doesn't need to be checked. Skipping."
  #     else
  #     CheckServiceJob.perform_later(self)
  #   end
  # end

  def check
    return unless check_is_needed

    self.http_screenshot = nil # Clear the old screenshots, regardless.

    if ping
      p = Net::Ping::External.new(host)
      self.ping_last = if p.ping
                         (p.duration * 1000).to_i
                       else
                         -1
                       end
    end
    host = self.host
    path = http_path
    path = '/index.html' if path.nil? || path == ''
    
    if http
      port = 80 if self.port == 0
      uri = URI("http://#{self.host}:#{port}#{http_path}")
      good = false
      begin
        Net::HTTP.start(uri.host, uri.port) do |http|
          request = Net::HTTP::Get.new uri
          response = http.request request # Net::HTTPResponse object
          code = response.code.to_i
          # puts "CODE: #{code}"
          self.http_path_last = (code >= 200 && code < 400)
        end
      rescue StandardError => e
        # Possibly a DNS failure or something.
        self.http_path_last = false
        # Rails.logger.debug e
      end

      if http_xquery
        # TODO
      end
    end

    if https
      port = 443 if self.port == 0
      puts "Checking #{name} HTTPS"
      uri = URI("https://#{self.host}:#{port}#{http_path}")
      good = false
      begin
        Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |https|
          request = Net::HTTP::Get.new uri
          response = https.request request # Net::HTTPResponse object
          code = response.code.to_i
          # puts "CODE HTTPS: #{code}"
          self.https_path_last = (code >= 200 && code < 400)
        end
      rescue StandardError => e
        # Possibly a DNS failure or something.
        self.https_path_last = false
        # Rails.logger.debug e
      end
    end

    if http_preview && (http || https)
      uri = URI("http://#{self.host}:#{self.port == 0 ? 80 : self.port}#{http_path}")
      uri = URI("https://#{self.host}:#{self.port == 0 ? 443 : self.port}#{http_path}") if https
      puts "URI for screenshot is #{uri}"
      begin
        self.http_screenshot = nil
        Puppeteer.launch(headless: true, slow_mo: 50,
                         args: [
                           '--disable-gpu',
                           '--disable-setuid-sandbox',
                           '--disable-web-security',
                           '--no-first-run',
                           '--no-sandbox',
                           '--window-size=1280,800'
                         ]) do |browser|
          # end
          # BROWSER_LOCK.synchronize do
          page = browser.new_page
          page.viewport = Puppeteer::Viewport.new(width: 1280, height: 1280)
          # page.timeout = 5000
          page.goto(uri.to_s, timeout: 5000) # , wait_until: 'domcontentloaded')
          self.http_screenshot = page.screenshot
          browser.close
          # puts out.to_s

          # puts "Visiting #{uri}"
          # BROWSER.reset!
          # BROWSER.visit uri.to_s
          # sleep 0.100 # Brief artificial delay for rendering. :(

          # tmp = Tempfile.new(['tmp', '.png'])
          # self.http_screenshot = IO.read 'tmp.png'
          # debug
          # puts data
          # # puts tmp.path
          # begin
          # 	BROWSER.driver.render tmp.path,
          # 	  :width  => PHOTO_OPTS[:w] + PHOTO_OPTS[:x],
          # 	  :height => PHOTO_OPTS[:h] + PHOTO_OPTS[:y]
          # 	self.http_screenshot = IO.read tmp.path
          # ensure
          # 	tmp.close # Close and delete the temporary file.
          # 	tmp.unlink
          # end
        end
      rescue StandardError => e
        # The visit will throw an exception if it times out.
        puts 'Failed to capture screenshot.'
        puts e
      end

    end

    self.checked_at = Time.now
    save!
  end

  def known_good(since)
    known = false
    if !checked_at.nil? && (since.nil? || checked_at >= since)
      ping_good = !ping || (!ping_last.nil? && ping_last >= 0 && ping_last <= ping_threshold)
      http_good = !http || http_path_last
      https_good = !https || https_path_last
      # TODO: xquery_good = (self.http_xquery.nil? || self.http_xquery == '' || (self.http_xquery && TODO))
      known = true if ping_good && http_good && https_good
    end
    known
  end

  def known_bad(since)
    known = false
    if (checked_at && since.nil?) || (!since.nil? && checked_at >= since)
      ping_bad = ping && !ping_last.nil? && (ping_last > ping_threshold || ping_last < 0)
      http_bad = http && !http_path_last
      https_bad = https && !https_path_last
      # xquery_bad = self.http_xquery && TODO
      known = true if ping_bad || http_bad || https_bad
    end
    known
  end
end
