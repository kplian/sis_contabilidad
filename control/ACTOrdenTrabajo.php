<?php
/**
*@package pXP
*@file ACTOrdenTrabajo.php
*@author  Gonzalo Sarmiento Sejas
*@date 21-02-2013 21:08:55
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTOrdenTrabajo extends ACTbase{    
			
	function listarOrdenTrabajo(){
		$this->objParam->defecto('ordenacion','id_orden_trabajo');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODOrdenTrabajo','listarOrdenTrabajo');
		} else{
			$this->objFunc=$this->create('MODOrdenTrabajo');
			
			$this->res=$this->objFunc->listarOrdenTrabajo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarOrdenTrabajo(){
		$this->objFunc=$this->create('MODOrdenTrabajo');	
		if($this->objParam->insertar('id_orden_trabajo')){
			$this->res=$this->objFunc->insertarOrdenTrabajo($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarOrdenTrabajo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarOrdenTrabajo(){
			$this->objFunc=$this->create('MODOrdenTrabajo');	
		$this->res=$this->objFunc->eliminarOrdenTrabajo($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>