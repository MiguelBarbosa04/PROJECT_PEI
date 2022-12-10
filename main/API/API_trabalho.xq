module namespace page = 'http://basex.org/examples/web-page';

declare namespace per = 'peritagem.xsd';
declare namespace m = 'marcacoes.xsd';
declare namespace s = 'servicos.xsd';
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

declare (:Apresentar as marcações associadas a um perito para o dia atual;:)
  %rest:path("/marcacao/perito")
  %rest:GET
  %rest:query-param("perito", "{$perito}")

  
  function page:getPeritagemByPerito($perito as xs:string) {
     let $dia_atual := fn:format-date(fn:current-date(),"[Y0001]-[M01]-[D01]" ) 
    
    for $marcacao in db:open("marcacoes")//marcacao
    where $marcacao/m:perito=$perito and $marcacao//m:dia = $dia_atual
    return  $marcacao
    
};

declare (:Apresentar as peritagens realizadas/não realizadas num determinado dia para um dado parceiro;:)
  %rest:path("/peritagem/parceiro")
  %rest:GET
  %rest:query-param("parceiro", "{$parceiro}")
  %rest:query-param("dia", "{$dia}")
  
  function page:getPeritagemByParceiro($parceiro as xs:string, $dia as xs:date) {
    
    
    for $peritagem in db:open("servicos")//peritagem
    where $peritagem/per:parceiro=$parceiro and $peritagem//per:dia = $dia
    return  $peritagem
};
  
  
declare (:Consultar os dados de uma peritagem.:)
  %rest:path("/peritagem/{$id}")
  %rest:GET
  
  function page:getPeritagemById($id) {
    
    for $peritagem in db:open("servicos")//peritagem
    where $peritagem[@id = $id]
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
      {$body//m:parceiro,$body//m:perito, $body//m:data, $body//m:local , $body//m:veiculo}
    </marcacao>
  )
    
    return (update:output("Sucesso. Servico válido"), db:add("marcacoes", $newbody, "marcacoes.xml"))
    
};

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

