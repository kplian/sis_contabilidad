<?php
/**
*@package pXP
*@file gen-ACTTipoCcOt.php
*@author  (admin)
*@date 31-05-2017 22:07:39
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTTipoCcOt extends ACTbase{    
			
	function listarTipoCcOt(){
		$this->objParam->defecto('ordenacion','id_tipo_cc_ot');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTipoCcOt','listarTipoCcOt');
		} else{
			$this->objFunc=$this->create('MODTipoCcOt');
			
			$this->res=$this->objFunc->listarTipoCcOt($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarTipoCcOt(){
		$this->objFunc=$this->create('MODTipoCcOt');	
		if($this->objParam->insertar('id_tipo_cc_ot')){
			$this->res=$this->objFunc->insertarTipoCcOt($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarTipoCcOt($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarTipoCcOt(){
			$this->objFunc=$this->create('MODTipoCcOt');	
		$this->res=$this->objFunc->eliminarTipoCcOt($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>