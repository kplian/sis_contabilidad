<?php
/**
*@package pXP
*@file gen-ACTAgrupador.php
*@author  (admin)
*@date 22-09-2015 16:47:53
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTAgrupador extends ACTbase{    
			
	function listarAgrupador(){
		$this->objParam->defecto('ordenacion','id_agrupador');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODAgrupador','listarAgrupador');
		} else{
			$this->objFunc=$this->create('MODAgrupador');
			
			$this->res=$this->objFunc->listarAgrupador($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarAgrupador(){
		$this->objFunc=$this->create('MODAgrupador');	
		if($this->objParam->insertar('id_agrupador')){
			$this->res=$this->objFunc->insertarAgrupador($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarAgrupador($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarAgrupador(){
		$this->objFunc=$this->create('MODAgrupador');	
		$this->res=$this->objFunc->eliminarAgrupador($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

    function generarAgrupacion(){
		$this->objFunc=$this->create('MODAgrupador');	
		$this->res=$this->objFunc->generarAgrupacion($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}



			
}

?>