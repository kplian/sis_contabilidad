<?php
/**
*@package pXP
*@file gen-ACTTipoRelacionComprobante.php
*@author  (admin)
*@date 17-12-2014 19:29:44
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTTipoRelacionComprobante extends ACTbase{    
			
	function listarTipoRelacionComprobante(){
		$this->objParam->defecto('ordenacion','id_tipo_relacion_comprobante');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTipoRelacionComprobante','listarTipoRelacionComprobante');
		} else{
			$this->objFunc=$this->create('MODTipoRelacionComprobante');
			
			$this->res=$this->objFunc->listarTipoRelacionComprobante($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarTipoRelacionComprobante(){
		$this->objFunc=$this->create('MODTipoRelacionComprobante');	
		if($this->objParam->insertar('id_tipo_relacion_comprobante')){
			$this->res=$this->objFunc->insertarTipoRelacionComprobante($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarTipoRelacionComprobante($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarTipoRelacionComprobante(){
			$this->objFunc=$this->create('MODTipoRelacionComprobante');	
		$this->res=$this->objFunc->eliminarTipoRelacionComprobante($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>