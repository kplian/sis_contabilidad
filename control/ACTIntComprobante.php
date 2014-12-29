<?php
/**
*@package pXP
*@file gen-ACTIntComprobante.php
*@author  (admin)
*@date 29-08-2013 00:28:30
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/
//require_once(dirname(__FILE__).'/../../lib/lib_reporte/ReportePDF2.php');
require_once(dirname(__FILE__).'/../../lib/lib_reporte/PlantillasHTML.php');
require_once(dirname(__FILE__).'/../../lib/lib_reporte/smarty/ksmarty.php');

class ACTIntComprobante extends ACTbase{
	
	private $objPlantHtml;
	
	function listarIntComprobante(){
		$this->objParam->defecto('ordenacion','id_int_comprobante');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		$this->objParam->addFiltro("incbte.estado_reg = ''borrador''");
		
		if($this->objParam->getParametro('id_deptos')!=''){
            $this->objParam->addFiltro("incbte.id_depto in (".$this->objParam->getParametro('id_deptos').")");    
        }
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODIntComprobante','listarIntComprobante');
		} else{
			$this->objFunc=$this->create('MODIntComprobante');
			
			$this->res=$this->objFunc->listarIntComprobante($this->objParam);
		}
		
		//echo dirname(__FILE__).'/../../lib/lib_reporte/ReportePDF2.php';exit;
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function listarSimpleIntComprobante(){
		$this->objParam->defecto('ordenacion','id_int_comprobante');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		$this->objParam->addFiltro("inc.estado_reg = ''validado''");
		
		if($this->objParam->getParametro('id_deptos')!=''){
            $this->objParam->addFiltro("inc.id_depto in (".$this->objParam->getParametro('id_deptos').")");    
        }
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODIntComprobante','listarSimpleIntComprobante');
		} else{
			$this->objFunc=$this->create('MODIntComprobante');
			
			$this->res=$this->objFunc->listarSimpleIntComprobante($this->objParam);
		}
		
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
				
	function insertarIntComprobante(){
		$this->objFunc=$this->create('MODIntComprobante');	
		if($this->objParam->insertar('id_int_comprobante')){
			$this->res=$this->objFunc->insertarIntComprobante($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarIntComprobante($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarIntComprobante(){
		$this->objFunc=$this->create('MODIntComprobante');	
		$this->res=$this->objFunc->eliminarIntComprobante($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function validarIntComprobante(){
		$this->objFunc=$this->create('MODIntComprobante');	
		$this->res=$this->objFunc->validarIntComprobante($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	//Cabecera reporte comprobante
	function listarCbteCabecera(){
		$this->objParam->defecto('ordenacion','id_int_comprobante');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODIntComprobante','listarCbteCabecera');
		} else{
			$this->objFunc=$this->create('MODIntComprobante');
			$this->res=$this->objFunc->listarCbteCabecera($this->objParam);
		}

		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	//Detalle reporte comprobante
	function listarCbteDetalle(){
		$this->objParam->defecto('ordenacion','id_int_comprobante');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODIntComprobante','listarCbteDetalle');
		} else{
			$this->objFunc=$this->create('MODIntComprobante');
			$this->res=$this->objFunc->listarCbteDetalle($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function reporteComprobante1(){
		$this->objFunc=$this->create('MODIntComprobante');
		
		//
		//Seteo de los parámetros generales del reporte
		//
		//Configuración
		$this->objParam->addParametro('orientation','P');
		$this->objParam->addParametro('unit','mm');
		$this->objParam->addParametro('format','Letter');
		$this->objParam->addParametro('unicode',true);
		$this->objParam->addParametro('encoding','UTF-8');
		$this->objParam->addParametro('diskcache',false);
		$this->objParam->addParametro('pdfa',false);
		//Archivo
		$this->objParam->addParametro('nombre_archivo','pxp_conta_comprobante');
		$this->objParam->addParametro('title1','REGISTRO');
		$this->objParam->addParametro('title2','Comprobante');
		
		$this->objParam->addParametro('header_key_right1','Cbte.');
		$this->objParam->addParametro('header_key_right2','Rev.');
		$this->objParam->addParametro('header_key_right3','Fecha.');
		$this->objParam->addParametro('header_key_right4','Pagina.');
		$this->objParam->addParametro('header_value_right1','DCC-CD-090001/2013');
		$this->objParam->addParametro('header_value_right2','1.0');
		$this->objParam->addParametro('header_value_right3','10/09/2013');
		$this->objParam->addParametro('header_value_right4','12');
		
		//Instancia de las plantillas
		$this->objPlantHtml=new PlantillasHTML($this->objParam);
		$this->objPlantHtml->setSeleccionarPlantilla('header',0);
		$header=$this->objPlantHtml->getPlantilla();
		$this->objPlantHtml->setSeleccionarPlantilla('footer',0);
		$footer=$this->objPlantHtml->getPlantilla();
			
	
		//Instancia la clase de reportes
		$this->objReporte = new ReportePDF2($this->objParam);
		$this->objReporte->setHeaderHtml($header);
		$this->objReporte->setFooterHtml($footer);

		//Genera el reporte		
		$this->objReporte->generarReporte();
		
		//Salida
		$mensajeExito = new Mensaje();
		$mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$this->objParam->getParametro('nombre_archivo'),'control');
		$mensajeExito->setArchivoGenerado($this->objReporte->getNombreArchivo());
		$this->res = $mensajeExito;
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function reporteComprobante(){
		/////////////////////
		//Obtención de datos
		/////////////////////
		//Cabecera (firmas)
		$this->objFunc=$this->create('MODIntComprobante');
		$cbteHeader = $this->objFunc->listarCbteCabecera($this->objParam);
		$cbteHeaderData=$cbteHeader->getDatos();
		
		//Detalle transacciones
		$this->objFunc=$this->create('MODIntComprobante');
		$cbteTrans = $this->objFunc->listarCbteDetalle($this->objParam);
		$cbteTransData=$cbteTrans->getDatos();
		
		//Se obtienen la suma de debe y haber
		$arrTotalesCbte= array('tot_ejec'=>0,'tot_debe'=>0,'tot_haber'=>0,'tot_debe1'=>0,'tot_haber1'=>0);
		
		foreach($cbteTransData as $key=>$val){
			$arrTotalesCbte['tot_debe']+=$val['importe_debe'];
			$arrTotalesCbte['tot_haber']+=$val['importe_haber'];
			$arrTotalesCbte['tot_debe1']+=$val['importe_debe1'];
			$arrTotalesCbte['tot_haber1']+=$val['importe_haber1'];
		}
		
		/*echo '<pre>';
		print_r($cbteTransData);
		echo '</pre>';
		exit;*/
		
		
		//Reporte
		$repCbte = new ksmarty();
		
		//////////
		//Header
		//////////
		$repCbte->assign('main_title1','COMPROBANTE DIARIO'); //dinámico
		$repCbte->assign('main_title2','MOMENTO PRESUPUESTARIO: DEVENGADO');//dinámico
		$repCbte->assign('header_key_right1','Depto.');
		$repCbte->assign('header_key_right2','N°');
		$repCbte->assign('header_key_right3','Fecha');
		$repCbte->assign('header_value_right1',$cbteHeaderData[0]['cod_depto']);//dinámico
		$repCbte->assign('header_value_right2',$cbteHeaderData[0]['nro_cbte']);//dinámico
		$repCbte->assign('header_value_right3',$cbteHeaderData[0]['fecha']);//dinámico
		$header = $repCbte->fetch($repCbte->getTplHeader());
		
		//echo $header;exit;
		
		/////////
		//Labels
		/////////
		$repCbte->setTemplateDir(dirname(__FILE__).'/../reportes/tpl_comprobante/');
		$labels=$repCbte->fetch('labels.tpl');
		
		
		/////////
		//Footer
		/////////
		$repCbte->setTemplateDir(dirname(__FILE__).'/../reportes/tpl_comprobante/');
		$repCbte->assign('etiqueta1','Centro Responsable');
		$repCbte->assign('etiqueta2','Elaborado por');
		$repCbte->assign('etiqueta3','Beneficiario');
		$repCbte->assign('etiqueta4','VoBo');
		$repCbte->assign('firma1',$cbteHeaderData[0]['firma1']);
		$repCbte->assign('firma2',$cbteHeaderData[0]['firma2']);
		$repCbte->assign('firma3',$cbteHeaderData[0]['firma3']);
		$repCbte->assign('firma4',$cbteHeaderData[0]['firma4']);
		$repCbte->assign('cargo1',$cbteHeaderData[0]['firma1_cargo']);
		$repCbte->assign('cargo2',$cbteHeaderData[0]['firma2_cargo']);
		$repCbte->assign('cargo3',$cbteHeaderData[0]['firma3_cargo']);
		$repCbte->assign('cargo4',$cbteHeaderData[0]['firma4_cargo']);
		$footer = $repCbte->fetch('footer.tpl');
		
		
		//////////
		//Master
		//////////
		$repCbte->setTemplateDir(dirname(__FILE__).'/../reportes/tpl_comprobante/');
		$repCbte->assign('acreedor',$cbteHeaderData[0]['beneficiario']); //dinámico
		$repCbte->assign('conformidad',$cbteHeaderData[0]['glosa1']); //dinámico
		$repCbte->assign('operacion',$cbteHeaderData[0]['glosa2']); //dinámico
		$repCbte->assign('tipo_cambio',$cbteHeaderData[0]['tipo_cambio']); //dinámico
		$repCbte->assign('facturas','Facturas 1 2'); //dinámico
		$repCbte->assign('pedido','Pedido G'); //dinámico
		$repCbte->assign('aprobacion','Aprobación V'); //dinámico
		$master=$repCbte->fetch('master.tpl');
		
		
		/////////
		//Detail
		/////////
		$repCbte->assign('transac',$cbteTransData); //dinámico
		$repCbte->assign('tot_ejecucion_bs',$arrTotalesCbte['tot_ejec']); //dinámico
		$repCbte->assign('tot_importe_debe1',$arrTotalesCbte['tot_debe1']); //dinámico
		$repCbte->assign('tot_importe_haber1',$arrTotalesCbte['tot_haber1']); //dinámico
		$repCbte->assign('tot_importe_debe',$arrTotalesCbte['tot_debe']); //dinámico
		$repCbte->assign('tot_importe_haber',$arrTotalesCbte['tot_haber']); //dinámico
		$detail=$repCbte->fetch('comprobante.tpl');
		

/*		
		///////////////////
		//Creación de pdf
		///////////////////
		$this->objParam->addParametro('orientation','P');
		$this->objParam->addParametro('unit','mm');
		$this->objParam->addParametro('format','Letter');
		$this->objParam->addParametro('unicode',true);
		$this->objParam->addParametro('encoding','UTF-8');
		$this->objParam->addParametro('diskcache',false);
		$this->objParam->addParametro('pdfa',false);
		//Archivo
		$this->objParam->addParametro('nombre_archivo','pxp_comprobante');
		
		/*$header='<table border="1" cellspacing="0" cellpadding="1">
				<tr>
					<td width="23%" rowspan="4"><img src="../../lib/lib_reporte/logo.png" border="0" width=156 height=117 /></td>
					<td align="center" width="54%" rowspan="2">**main_title1**</td>
					<td width="23%">**header_key_right1**: **header_value_right1**</td>
				</tr>
				<tr>
					<td width="23%">**header_key_right2**: **header_value_right2**</td>
				</tr>
				<tr>
					<td align="center" width="54%" rowspan="2">**main_title2**</td>
					<td width="23%">**header_key_right3**: **header_value_right3**</td>
				</tr>
				<tr>
					<td width="23%">Página **main_pagina_actual** de **main_pagina_total**</td>
				</tr>
			</table>';*/
/*			
			$header1 = <<<EOF
<!-- EXAMPLE OF CSS STYLE -->
<style>
	h1 {
		color: navy;
		font-family: times;
		font-size: 24pt;
		text-decoration: underline;
	}
	p.first {
		color: #003300;
		font-family: helvetica;
		font-size: 12pt;
	}
	p.first span {
		color: #006600;
		font-style: italic;
	}
	p#second {
		color: rgb(00,63,127);
		font-family: times;
		font-size: 12pt;
		text-align: justify;
	}
	p#second > span {
		background-color: #FFFFAA;
	}
	table.first {
		color: #003300;
		font-family: helvetica;
		font-size: 8pt;
		border-left: 3px solid red;
		border-right: 3px solid #FF00FF;
		border-top: 3px solid green;
		border-bottom: 3px solid blue;
		background-color: #ccffcc;
	}
	td {
		border: 2px solid blue;
		background-color: #ffffee;
	}
	td.second {
		border: 2px dashed green;
	}
	div.test {
		color: #CC0000;
		background-color: #FFFF66;
		font-family: helvetica;
		font-size: 10pt;
		border-style: solid solid solid solid;
		border-width: 2px 2px 2px 2px;
		border-color: green #FF00FF blue red;
		text-align: center;
	}
</style>

<h1 class="title">Example of <i style="color:#990000">XHTML + CSS</i></h1>

<p class="first">Example of paragraph with class selector. <span>Lorem ipsum dolor sit amet, consectetur adipiscing elit. In sed imperdiet lectus. Phasellus quis velit velit, non condimentum quam. Sed neque urna, ultrices ac volutpat vel, laoreet vitae augue. Sed vel velit erat. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Cras eget velit nulla, eu sagittis elit. Nunc ac arcu est, in lobortis tellus. Praesent condimentum rhoncus sodales. In hac habitasse platea dictumst. Proin porta eros pharetra enim tincidunt dignissim nec vel dolor. Cras sapien elit, ornare ac dignissim eu, ultricies ac eros. Maecenas augue magna, ultrices a congue in, mollis eu nulla. Nunc venenatis massa at est eleifend faucibus. Vivamus sed risus lectus, nec interdum nunc.</span></p>

<p id="second">Example of paragraph with ID selector. <span>Fusce et felis vitae diam lobortis sollicitudin. Aenean tincidunt accumsan nisi, id vehicula quam laoreet elementum. Phasellus egestas interdum erat, et viverra ipsum ultricies ac. Praesent sagittis augue at augue volutpat eleifend. Cras nec orci neque. Mauris bibendum posuere blandit. Donec feugiat mollis dui sit amet pellentesque. Sed a enim justo. Donec tincidunt, nisl eget elementum aliquam, odio ipsum ultrices quam, eu porttitor ligula urna at lorem. Donec varius, eros et convallis laoreet, ligula tellus consequat felis, ut ornare metus tellus sodales velit. Duis sed diam ante. Ut rutrum malesuada massa, vitae consectetur ipsum rhoncus sed. Suspendisse potenti. Pellentesque a congue massa.</span></p>

<div class="test">example of DIV with border and fill.<br />Lorem ipsum dolor sit amet, consectetur adipiscing elit. In sed imperdiet lectus.</div>

<br />

<table class="first" cellpadding="4" cellspacing="6">
 <tr>
  <td width="30" align="center"><b>No.</b></td>
  <td width="140" align="center" bgcolor="#FFFF00"><b>XXXX</b></td>
  <td width="140" align="center"><b>XXXX</b></td>
  <td width="80" align="center"> <b>XXXX</b></td>
  <td width="80" align="center"><b>XXXX</b></td>
  <td width="45" align="center"><b>XXXX</b></td>
 </tr>
 <tr>
  <td width="30" align="center">1.</td>
  <td width="140" rowspan="6" class="second">XXXX<br />XXXX<br />XXXX<br />XXXX<br />XXXX<br />XXXX<br />XXXX<br />XXXX</td>
  <td width="140">XXXX<br />XXXX</td>
  <td width="80">XXXX<br />XXXX</td>
  <td width="80">XXXX</td>
  <td align="center" width="45">XXXX<br />XXXX</td>
 </tr>
 <tr>
  <td width="30" align="center" rowspan="3">2.</td>
  <td width="140" rowspan="3">XXXX<br />XXXX</td>
  <td width="80">XXXX<br />XXXX</td>
  <td width="80">XXXX<br />XXXX</td>
  <td align="center" width="45">XXXX<br />XXXX</td>
 </tr>
 <tr>
  <td width="80">XXXX<br />XXXX<br />XXXX<br />XXXX</td>
  <td width="80">XXXX<br />XXXX</td>
  <td align="center" width="45">XXXX<br />XXXX</td>
 </tr>
 <tr>
  <td width="80" rowspan="2" >XXXX<br />XXXX<br />XXXX<br />XXXX<br />XXXX<br />XXXX<br />XXXX<br />XXXX</td>
  <td width="80">XXXX<br />XXXX</td>
  <td align="center" width="45">XXXX<br />XXXX</td>
 </tr>
 <tr>
  <td width="30" align="center">3.</td>
  <td width="140">XXXX<br />XXXX</td>
  <td width="80">XXXX<br />XXXX</td>
  <td align="center" width="45">XXXX<br />XXXX</td>
 </tr>
 <tr bgcolor="#FFFF80">
  <td width="30" align="center">4.</td>
  <td width="140" bgcolor="#00CC00" color="#FFFF00">XXXX<br />XXXX</td>
  <td width="80">XXXX<br />XXXX</td>
  <td width="80">XXXX<br />XXXX</td>
  <td align="center" width="45">XXXX<br />XXXX</td>
 </tr>
</table>
EOF;
			
	
		//Instancia la clase de reportes
		$this->objReporte = new ReportePDF2($this->objParam);
		$this->objReporte->setHeaderHtml('<<<EOF'.$header.'EOF');
		//$this->objReporte->setFooterHtml($footer);

		//Genera el reporte		
		$this->objReporte->generarReporte();
		$mensajeExito = new Mensaje();
		$mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$this->objParam->getParametro('nombre_archivo'),'control');
		$mensajeExito->setArchivoGenerado($this->objReporte->getNombreArchivo());
		$this->res = $mensajeExito;
		$this->res->imprimirRespuesta($this->res->generarJson());
		exit;
		
		
		
		
		*/
		
		
		////////////////////////////
		//Creación del archivo html
		////////////////////////////
		//$html = $header.'<br>'.$master.'<br>'.$labels.'<br>'.$detail.'<br>'.$footer;
		$html = $header.$master.$labels.$detail.$footer;
		//echo 'resp:'.$html; exit;
		
		$repCbte->generarArchivo($html,'pxp_comprobante');
		
		$mensajeExito = new Mensaje();
		$mensajeExito->setMensaje('EXITO',dirname(__FILE__),'Salida generada','Se generó la salida HTML con éxito','control','reporteComprobante');
		$mensajeExito->setArchivoGenerado($repCbte->getFileName());
		$this->res = $mensajeExito;
		$this->res->imprimirRespuesta($this->res->generarJson());
		
		
		
	}
			
}

?>