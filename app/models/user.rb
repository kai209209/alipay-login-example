class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def self.redirect_to_alipay_login_gateway
    options = { "service" => "alipay.auth.authorize",
                "partner" => "alipay_pid: 123456", 
                "_input_charset" => "utf-8", 
                "return_url" =>  "abc.com:3000(本地调试)", 
                "target_service" => "user.auth.quick.login" }
    options.merge!("sign_type" => "MD5", 
                   "sign" => Digest::MD5.hexdigest(options.sort.map{|k, v| "#{k}=#{v}"}.join("&") + "alipay_key: 123456"))
    "https://mapi.alipay.com/gateway.do?#{options.sort.map{|k,v|"#{CGI::escape(k.to_s)}=#{CGI::escape(v.to_s)}"}.join("&")}"
  end
end
