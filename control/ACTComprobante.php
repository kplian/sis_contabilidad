<?php
/**
*@package pXP
*@file gen-ACTComprobante.php
*@author  (admin)
*@date 29-08-2013 00:28:30
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTComprobante extends ACTbase{    
			
	function listarComprobante(){
		$this->objParam->defecto('ordenacion','id_comprobante');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		$this->objParam->addFiltro("cbte.estado_reg = ''validado''");
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODComprobante','listarComprobante');
		} else{
			$this->objFunc=$this->create('MODComprobante');
			
			$this->res=$this->objFunc->listarComprobante($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarComprobante(){
		$this->objFunc=$this->create('MODComprobante');	
		if($this->objParam->insertar('id_comprobante')){
			$this->res=$this->objFunc->insertarComprobante($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarComprobante($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarComprobante(){
		$this->objFunc=$this->create('MODComprobante');	
		$this->res=$this->objFunc->eliminarComprobante($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function validarComprobante(){
		$this->objFunc=$this->create('MODComprobante');	
		$this->res=$this->objFunc->validarComprobante($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>