module namespace page = 'http://basex.org/examples/web-page';

declare namespace per = 'peritagem.xsd';
declare namespace m = 'marcacoes.xsd';
declare namespace s = 'servicos.xsd';


declare
  %updating
  %rest:path("/addperitagem")
  %rest:POST("{$body}")
  
  function page:addperitagem($body) {

    
    let $marcacaoId :=  db:open("marcacoes")//m:marcacao/@id/string()
    
    let $validate := $body//s:peritagem[@id = $marcacaoId]
       
    let $some := some $body in ("API_trabalho.xq") satisfies ($validate)
       
    return if ($some) then 
      (update:output("Sucesso. Servico válido"), insert node $body//s:peritagem as last into db:open("servicos")//s:servicos)
      else
      (update:output("Erro! Id da peritagem inválido."))
      
     
  
(: Validar id peritagem com id marcação!!! :)
    
};



declare
  %updating
  %rest:path("/update/peritagem")
  %rest:PUT("{$body}")
  %rest:query-param("id", "{$id}")
  
  function page:addperitagem($id as xs:string,$body) {
    
    let $check := fn:exists(db:open("servicos")//s:peritagem[@id = $id])
       
    return if ($check) then 
      (update:output("Sucesso. Documento Substituído"), replace node db:open("servicos")//s:peritagem[@id = $id] with $body//s:peritagem)
      else
      (update:output("Erro! Id não existe."))
};

declare (:Apresentar as marcações associadas a um perito para o dia atual;:)
  %rest:path("/marcacao/perito")
  %rest:GET
  %rest:query-param("perito", "{$perito}")

  
  function page:getPeritagemByPerito($perito as xs:string) {
     let $dia_atual := fn:format-date(fn:current-date(),"[Y0001]-[M01]-[D01]" ) 
    
    for $marcacao in db:open("marcacoes")//m:marcacao
    where $marcacao/m:perito=$perito and $marcacao//m:dia = $dia_atual
    return  $marcacao
    
};

declare (:Apresentar as peritagens realizadas/não realizadas num determinado dia para um dado parceiro;:)
  %rest:path("/peritagem/parceiro")
  %rest:GET
  %rest:query-param("parceiro", "{$parceiro}")
  %rest:query-param("dia", "{$dia}")
  
  function page:getPeritagemByParceiro($parceiro as xs:string, $dia as xs:date) {
    
    
    for $peritagem in db:open("servicos")//s:peritagem
    where $peritagem/per:parceiro=$parceiro and $peritagem//per:dia = $dia
    return  $peritagem
};
  
  
declare (:Consultar os dados de uma peritagem.:)
  %rest:path("/peritagem/{$id}")
  %rest:GET
  
  function page:getPeritagemById($id) {
    
    for $peritagem in db:open("servicos")//s:peritagem
    where $peritagem[@id = $id]
    return $peritagem
  };
  


declare
  %updating
  %rest:path("/addmarcacao")
  %rest:POST("{$body}")
  
  function page:addmarcacao($body) {
    
    let $b := $body//m:marcacao
    
    return (update:output("Sucesso. Marcação Inserida!"), insert node $b as last into db:open("marcacoes")//m:marcacoes)
    
};

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

