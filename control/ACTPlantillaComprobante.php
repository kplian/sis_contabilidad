<?php
/**
*@package pXP
*@file gen-ACTPlantillaComprobante.php
*@author  (admin)
*@date 10-06-2013 14:40:00
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTPlantillaComprobante extends ACTbase{    
			
	function listarPlantillaComprobante(){
		$this->objParam->defecto('ordenacion','id_plantilla_comprobante');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPlantillaComprobante','listarPlantillaComprobante');
		} else{
			$this->objFunc=$this->create('MODPlantillaComprobante');
			
			$this->res=$this->objFunc->listarPlantillaComprobante($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarPlantillaComprobante(){
		$this->objFunc=$this->create('MODPlantillaComprobante');	
		if($this->objParam->insertar('id_plantilla_comprobante')){
			$this->res=$this->objFunc->insertarPlantillaComprobante($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarPlantillaComprobante($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarPlantillaComprobante(){
			$this->objFunc=$this->create('MODPlantillaComprobante');	
		$this->res=$this->objFunc->eliminarPlantillaComprobante($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>