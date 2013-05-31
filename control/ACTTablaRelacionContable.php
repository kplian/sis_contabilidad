<?php
/**
*@package pXP
*@file gen-ACTTablaRelacionContable.php
*@author  (admin)
*@date 16-05-2013 21:05:26
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTTablaRelacionContable extends ACTbase{    
			
	function listarTablaRelacionContable(){
		$this->objParam->defecto('ordenacion','id_tabla_relacion_contable');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTablaRelacionContable','listarTablaRelacionContable');
		} else{
			$this->objFunc=$this->create('MODTablaRelacionContable');
			
			$this->res=$this->objFunc->listarTablaRelacionContable($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarTablaRelacionContable(){
		$this->objFunc=$this->create('MODTablaRelacionContable');	
		if($this->objParam->insertar('id_tabla_relacion_contable')){
			$this->res=$this->objFunc->insertarTablaRelacionContable($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarTablaRelacionContable($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarTablaRelacionContable(){
			$this->objFunc=$this->create('MODTablaRelacionContable');	
		$this->res=$this->objFunc->eliminarTablaRelacionContable($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>