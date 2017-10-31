<?php
/**
*@package pXP
*@file gen-ACTTipoEstadoCuenta.php
*@author  (admin)
*@date 26-07-2017 21:48:36
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

require_once(dirname(__FILE__).'/../reportes/RTipoestadocuenta.php');

class ACTTipoEstadoCuenta extends ACTbase{    
			
	function listarTipoEstadoCuenta(){
		$this->objParam->defecto('ordenacion','id_tipo_estado_cuenta');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTipoEstadoCuenta','listarTipoEstadoCuenta');
		} else{
			$this->objFunc=$this->create('MODTipoEstadoCuenta');
			
			$this->res=$this->objFunc->listarTipoEstadoCuenta($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function listarEstadoCuenta(){
		$this->objParam->defecto('ordenacion','id_tipo_estado_columna');
		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTipoEstadoCuenta','listarEstadoCuenta');
		} else{
			$this->objFunc=$this->create('MODTipoEstadoCuenta');			
			$this->res=$this->objFunc->listarEstadoCuenta($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
			
	function insertarTipoEstadoCuenta(){
		$this->objFunc=$this->create('MODTipoEstadoCuenta');	
		if($this->objParam->insertar('id_tipo_estado_cuenta')){
			$this->res=$this->objFunc->insertarTipoEstadoCuenta($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarTipoEstadoCuenta($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarTipoEstadoCuenta(){
			$this->objFunc=$this->create('MODTipoEstadoCuenta');	
		$this->res=$this->objFunc->eliminarTipoEstadoCuenta($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	//recupera de acuerdo al id_auxiliar ../../sis_contabilidad/control/Auxiliar/listarAuxiliar
	function recuperarDatosAuxiliar(){    	
		$this->objFunc = $this->create('MODAuxiliar');
		$cbteHeader = $this->objFunc->getAuxiliar($this->objParam);		
		if($cbteHeader->getTipo() == 'EXITO'){				
			return $cbteHeader;
		}
		else{
			$cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}
	}	
	//recupera de acuerdo al id_tipo_estado_cuenta
	function recuperarDatosTipoEstadoCuenta(){    	
		$this->objFunc = $this->create('MODTipoEstadoCuenta');
		$cbteHeader = $this->objFunc->getTipoEstadoCuenta($this->objParam);
		if($cbteHeader->getTipo() == 'EXITO'){				
			return $cbteHeader;
		}
		else{
			$cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}
	}		
	//
	function recuperarDatos(){
		$this->objFunc = $this->create('MODTipoEstadoCuenta');
		$cbteHeader = $this->objFunc->listarDatos($this->objParam);
		if($cbteHeader->getTipo() == 'EXITO'){				
			return $cbteHeader;
		}
		else{
			$cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}
	}
	//mp
	function impReporte() {		
		$nombreArchivo = uniqid(md5(session_id()).'Egresos') . '.pdf';
		$orientacion = 'P';		
		$dataSource = $this->recuperarDatos();				
		$dataTpoestado = $this->recuperarDatosTipoEstadoCuenta();		
		$dataAuxiliar = $this->recuperarDatosAuxiliar();
		$tamano = 'LETTER';
		$titulo = 'Consolidado';
		$this->objParam->addParametro('orientacion',$orientacion);
		$this->objParam->addParametro('tamano',$tamano);		
		$this->objParam->addParametro('titulo_archivo',$titulo);	
		$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
		$reporte = new RTipoestadocuenta($this->objParam);  
		$reporte->datosHeader($dataSource->getDatos(),$dataSource->extraData, $dataTpoestado->getDatos(),$dataAuxiliar->getDatos());		
		$reporte->generarReporte();
		$reporte->output($reporte->url_archivo,'F');
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se genera con exito el reporte: '.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());	
	}
			
}

?>