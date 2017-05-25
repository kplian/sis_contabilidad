<?php
/**
*@package pXP
*@file gen-ACTOrdenSuborden.php
*@author  (admin)
*@date 15-05-2017 10:36:02
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTOrdenSuborden extends ACTbase{    
			
	function listarOrdenSuborden(){
		$this->objParam->defecto('ordenacion','id_orden_suborden');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('id_orden_trabajo')!=''){
			$this->objParam->addFiltro("orsuo.id_orden_trabajo = ".$this->objParam->getParametro('id_orden_trabajo'));	
		}
		
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODOrdenSuborden','listarOrdenSuborden');
		} else{
			$this->objFunc=$this->create('MODOrdenSuborden');
			
			$this->res=$this->objFunc->listarOrdenSuborden($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarOrdenSuborden(){
		$this->objFunc=$this->create('MODOrdenSuborden');	
		if($this->objParam->insertar('id_orden_suborden')){
			$this->res=$this->objFunc->insertarOrdenSuborden($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarOrdenSuborden($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarOrdenSuborden(){
			$this->objFunc=$this->create('MODOrdenSuborden');	
		$this->res=$this->objFunc->eliminarOrdenSuborden($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>