<?php
/**
*@package pXP
*@file gen-ACTDetallePlantillaComprobante.php
*@author  (admin)
*@date 10-06-2013 14:51:03
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTDetallePlantillaComprobante extends ACTbase{    
			
	function listarDetallePlantillaComprobante(){
		$this->objParam->defecto('ordenacion','id_detalle_plantilla_comprobante');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODDetallePlantillaComprobante','listarDetallePlantillaComprobante');
		} else{
			$this->objFunc=$this->create('MODDetallePlantillaComprobante');
			
			$this->res=$this->objFunc->listarDetallePlantillaComprobante($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarDetallePlantillaComprobante(){
		$this->objFunc=$this->create('MODDetallePlantillaComprobante');	
		if($this->objParam->insertar('id_detalle_plantilla_comprobante')){
			$this->res=$this->objFunc->insertarDetallePlantillaComprobante($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarDetallePlantillaComprobante($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarDetallePlantillaComprobante(){
			$this->objFunc=$this->create('MODDetallePlantillaComprobante');	
		$this->res=$this->objFunc->eliminarDetallePlantillaComprobante($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>