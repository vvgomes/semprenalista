describe Cabaret::JsNavigator do
  
  it 'should find the party links' do
    js = %q{
      document.write('<a href="rockpocket.htm">Saiba mais</a></li>');
      document.write('<a href="amnesia.htm">Saiba mais</a></li>');
      document.write('<a href="indiada.htm">Saiba mais</a></li>');
    }
    nav = Cabaret::JsNavigator.new js
    nav.hrefs.should be == ['rockpocket.htm', 'amnesia.htm', 'indiada.htm']
  end
  
  it 'should ignore code under single-line comments' do
    js = %q{
      document.write('<a href="rockpocket.htm">Saiba mais</a></li>');
      //document.write('<a href="amnesia.htm">Saiba mais</a></li>');
      document.write('<a href="indiada.htm">Saiba mais</a></li>');
    }
    nav = Cabaret::JsNavigator.new js
    nav.hrefs.should be == ['rockpocket.htm', 'indiada.htm']
  end
  
  it 'should ignore code under multi-line comments' do
    js = %q{
      /*document.write('<a href="rockpocket.htm">Saiba mais</a></li>');
      document.write('<a href="amnesia.htm">Saiba mais</a></li>');*/
      document.write('<a href="indiada.htm">Saiba mais</a></li>');
    }
    nav = Cabaret::JsNavigator.new js
    nav.hrefs.should be == ['indiada.htm']
  end
  
  it 'should avoid duplicated urls' do
    js = %q{
      document.write('<a href="amnesia.htm">Saiba mais</a></li>');
      document.write('<a href="amnesia.htm">Saiba mais</a></li>');
    }
    nav = Cabaret::JsNavigator.new js
    nav.hrefs.size.should be 1
  end
  
end