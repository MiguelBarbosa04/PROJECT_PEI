module namespace page = 'http://basex.org/examples/web-page';

declare namespace per = 'peritagem.xsd';

declare function page:createdb() {
  
 let $dbexists := db:exists("servicos")
   
  return if ($dbexists) then 
         (update:output("Base de Dados Existente!"))
       else 
        
         (update:output("Sucesso. Base de Dados Criada!"), db:create(servicos))
};
declare
  %updating
  %rest:path("/addservico")
  %rest:POST("{$body}")
  
  function page:addservico($body) {
    
    let $createdb := page:createdb()
    
    let $count := 1 + count(db:open("servicos")/peritagem) (: autoincrement ID :)
    
    let $newbody := (
    <peritagem id="{$count}">
      {$body//per:parceiro , $body//per:perito, $body//per:estado, $body//per:data, $body//per:entidade, $body//per:parametros}
    </peritagem>
  )
    
    return (update:output("Sucesso. Servico válido"), db:add("servicos", $newbody, "servico.xml"))
    
};

