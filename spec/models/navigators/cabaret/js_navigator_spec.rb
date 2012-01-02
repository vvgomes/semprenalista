describe Cabaret::JsNavigator do
  
  it 'should find the party links' do
    js = %q{
      document.write('<a href="rockpocket.htm">Saiba mais</a></li>');
      document.write('<a href="amnesia.htm">Saiba mais</a></li>');
      document.write('<a href="indiada.htm">Saiba mais</a></li>');
    }
    nav = Cabaret::JsNavigator.new js
    nav.hrefs.should be_eql ['rockpocket.htm', 'amnesia.htm', 'indiada.htm']
  end
  
  it 'should ignore code under single-line comments' do
    js = %q{
      document.write('<a href="rockpocket.htm">Saiba mais</a></li>');
      //document.write('<a href="amnesia.htm">Saiba mais</a></li>');
      document.write('<a href="indiada.htm">Saiba mais</a></li>');
    }
    nav = Cabaret::JsNavigator.new js
    nav.hrefs.should be_eql ['rockpocket.htm', 'indiada.htm']
  end
  
  it 'should ignore code under multi-line comments' do
    js = %q{
      /*document.write('<a href="rockpocket.htm">Saiba mais</a></li>');
      document.write('<a href="amnesia.htm">Saiba mais</a></li>');*/
      document.write('<a href="indiada.htm">Saiba mais</a></li>');
    }
    nav = Cabaret::JsNavigator.new js
    nav.hrefs.should be_eql ['indiada.htm']
  end
  
end