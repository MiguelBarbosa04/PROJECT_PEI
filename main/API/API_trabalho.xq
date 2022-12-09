module namespace page = 'http://basex.org/examples/web-page';

declare namespace per = 'peritagem.xsd';
declare namespace m = 'marcacoes.xsd';

declare function page:createdb() {
  
 (:let $dbexists := db:exists("servicos")
   
  return if ($dbexists) then 
         (update:output("Base de Dados Existente!"))
       else 
        
         (update:output("Sucesso. Base de Dados Criada!"), db:create(servicos))
         
         :)
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
  
(: Validar id peritagem com id marcação!!! :)
    
    return (update:output("Sucesso. Servico válido"), db:add("servicos", $newbody, "servico.xml"))
    
};

declare 
  %rest:path("/peritagem/{$id}")
  %rest:GET
  
  function page:getPeritagemById($id) {
    
    for $peritagem in db:open("servicos")//peritagem
    where $peritagem[@id = $id]
    return $peritagem
  };
  

declare 
  %rest:path("/peritagem/estado")
  %rest:GET
  %rest:query-param("estado", "{$estado}")
  
  function page:getPeritagemByStatus($estado as xs:string) {
    
    for $peritagem in db:open("servicos")//peritagem
    where $peritagem/per:estado[@type = $estado]
    return $peritagem
  };
  
declare
  %updating
  %rest:path("/addmarcacao")
  %rest:POST("{$body}")
  
  function page:addmarcacao($body) {
    
    let $createdb := page:createdb()
    
    let $count := 1 + count(db:open("marcacoes")/marcacao) (: autoincrement ID :)
    
    let $newbody := (
    <marcacao id="{$count}">
      {$body//m:local , $body//m:veiculo}
    </marcacao>
  )
    
    return (update:output("Sucesso. Servico válido"), db:add("marcacoes", $newbody, "marcacoes.xml"))
    
};

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

