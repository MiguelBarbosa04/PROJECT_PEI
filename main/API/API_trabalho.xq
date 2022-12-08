module namespace page = 'http://basex.org/examples/web-page';

declare
  %updating
  %rest:path("/addservico")
  %rest:POST("{$body}")
  
  function page:addservico($body) {
    update:output("Sucesso. Servico válido"), db:add("servico", $body, "servico.xml")
};