<?php
/**
*@package pXP
*@file gen-ACTMarca.php
*@author  (egutierrez)
*@date 10-06-2019 21:08:40
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTMarca extends ACTbase{    
			
	function listarMarca(){
		$this->objParam->defecto('ordenacion','id_marca');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODMarca','listarMarca');
		} else{
			$this->objFunc=$this->create('MODMarca');
			
			$this->res=$this->objFunc->listarMarca($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarMarca(){
		$this->objFunc=$this->create('MODMarca');	
		if($this->objParam->insertar('id_marca')){
			$this->res=$this->objFunc->insertarMarca($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarMarca($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarMarca(){
			$this->objFunc=$this->create('MODMarca');	
		$this->res=$this->objFunc->eliminarMarca($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>