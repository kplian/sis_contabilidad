<?php
/**
*@package pXP
*@file gen-ACTIntComprobante.php
*@author  (admin)
*@date 29-08-2013 00:28:30
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/
//require_once(dirname(__FILE__).'/../../lib/lib_reporte/ReportePDF2.php');
//require_once(dirname(__FILE__).'/../../lib/lib_reporte/PlantillasHTML.php');
//require_once(dirname(__FILE__).'/../../lib/lib_reporte/smarty/ksmarty.php');

class ACTIntComprobante extends ACTbase{
	
	private $objPlantHtml;
	
	function listarIntComprobante(){
		$this->objParam->defecto('ordenacion','id_int_comprobante');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		$this->objParam->addFiltro("incbte.estado_reg = ''borrador''");
		
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
		$repCbte = new ksmarty();
		
		/////////////////////
		//Obtención de datos
		/////////////////////
		
		
		//////////
		//Header
		//////////
		$repCbte->assign('main_title1','COMPROBANTE DIARIO'); //dinámico
		$repCbte->assign('main_title2','MOMENTO PRESUPUESTARIO: DEVENGADO');//dinámico
		$repCbte->assign('$header_key_right1','Depto.');
		$repCbte->assign('$header_key_right2','N°:');
		$repCbte->assign('$header_key_right3','Fecha');
		$repCbte->assign('$header_value_right1','DC-CENTRAL');//dinámico
		$repCbte->assign('$header_value_right2','060150');//dinámico
		$repCbte->assign('$header_value_right3','15/09/2013');//dinámico
		$header = $repCbte->fetch($this->getTplHeader());
		
		/////////
		//Labels
		/////////
		$arrLabels=array('Detalle','Ejecución Bs','Debe USD','Haber USD','Debe Bs','Haber Bs');
		$repCbte->assign('labels',$arrLabels); 
		$labels=$repCbte->fetch($this->getTplLabels());
		
		
		/////////
		//Footer
		/////////
		$repCbte->assign('main_sistema','Contabilidad');
		$footer = $repCbte->fetch($this->getTplFooter());
		
		//////////
		//Master
		//////////
		$repCbte->setTemplateDir('../reportes/comprobante');
		$repCbte->assign('acreedor','Acreedor X'); //dinámico
		$repCbte->assign('conformidad','Conformidad Y'); //dinámico
		$repCbte->assign('operacion','Operación Z'); //dinámico
		$repCbte->assign('tipo_cambio','Tipo Cambio A'); //dinámico
		$repCbte->assign('facturas','Facturas 1 2'); //dinámico
		$repCbte->assign('pedido','Pedido G'); //dinámico
		$repCbte->assign('aprobacion','Aprobación V'); //dinámico
		$master=$repCbte->fetch('master.tpl');
		
		
		/////////
		//Detail
		/////////
		$arrTransac[]=array('desc_centro_costo'=>'208 - FB - Administracion,',
							'desc_partida'=>'31140 - ALIMENTACION HOSPITALARIA, PENITENCIARIA, AERONAVES Y OTRAS ESPECIFICAS',
							'desc_cuenta'=>'61420.13.001 - ALIMENTACION A BORDO OPERATIVO',
							'desc_auxiliar'=>'50100001 - B 737-33A CP-2550 COSTO VARIABLE',
							'ejecucion_bs'=>'100',
							'debe_us'=>'13',
							'haber_us'=>'13',
							'debe_bs'=>'100',
							'haber_bs'=>'100');
		$repCbte->assign('transac',$arrTransac); //dinámico
		$detail=$repCbte->fetch('master.tpl');
		
		//Despliegue html
		$resp = $header.'<br>'.$master.'<br>'.$labels.'<br>'.$detail.'<br>'.$footer;
		echo $resp; exit;
		
		
		
	}
			
}

?>