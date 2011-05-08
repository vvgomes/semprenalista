#require 'mechanize'

class Nightclub
  
  def add_to_available_lists clubber
    parties.each do |party|
      
      data = {
        param_names[:party] => party,
        param_names[:name] => clubber.name,
        param_names[:email] => clubber.email
      }
      
      clubber.friends.each_with_index do |friend, i|
        data["amigo#{i+1}".to_sym] = friend
      end
      
      client = HttpClient.new
      client.post service, data
    end
  end
  
  private
  
  def parties
    ['londoncalling', 'rockpocket', 'amnesia']
  end
  
  def service
    'http://www.cabaretpoa.com.br/syscabaret/cadastra.php'
  end
  
  def param_names
    {
      :party => :festa,
      :name => :name,
      :email => :email,
      :friends => [:amigo1, :amigo2, :amigo3, :amigo4]
    }
  end
  
end