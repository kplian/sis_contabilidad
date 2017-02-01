<?php
/**
*@package pXP
*@file gen-ACTEntregaDet.php
*@author  (admin)
*@date 17-11-2016 19:50:46
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTEntregaDet extends ACTbase{    
			
	function listarEntregaDet(){
		$this->objParam->defecto('ordenacion','id_entrega_det');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_entrega')!=''){
			$this->objParam->addFiltro("ende.id_entrega = ".$this->objParam->getParametro('id_entrega'));	
		}
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODEntregaDet','listarEntregaDet');
		} else{
			$this->objFunc=$this->create('MODEntregaDet');
			
			$this->res=$this->objFunc->listarEntregaDet($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarEntregaDet(){
		$this->objFunc=$this->create('MODEntregaDet');	
		if($this->objParam->insertar('id_entrega_det')){
			$this->res=$this->objFunc->insertarEntregaDet($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarEntregaDet($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarEntregaDet(){
			$this->objFunc=$this->create('MODEntregaDet');	
		$this->res=$this->objFunc->eliminarEntregaDet($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>