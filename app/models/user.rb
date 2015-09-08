class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def self.redirect_to_alipay_login_gateway
    options = { "service" => "alipay.auth.authorize",
                "partner" => "填写申请的alipay id", 
                "_input_charset" => "utf-8", 
                "return_url" =>  "abc.com:3000(本地调试)", 
                "target_service" => "user.auth.quick.login" }
    options.merge!("sign_type" => "MD5", 
                   "sign" => Digest::MD5.hexdigest(options.sort.map{|k, v| "#{k}=#{v}"}.join("&") + "填写申请的alipay key"))
    "https://mapi.alipay.com/gateway.do?#{options.sort.map{|k,v|"#{CGI::escape(k.to_s)}=#{CGI::escape(v.to_s)}"}.join("&")}"
  end

  def self.from_alipay(params)
    where(uid: params[:user_id]).first_or_create do |user| 
      user.uid = params[:user_id]
      user.name = params[:real_name]
    end
  end

  def self.alipay_valid_check(notify_id)
    url = URI("https://mapi.alipay.com/gateway.do")
    url.query = URI.encode_www_form(
      'service' => 'notify_id',
      'partner' => '填写申请的alipay id',
      'notify_id' => notify_id
    )
    Net::HTTP.get(url) == "true"
  end
end
