<?php
/**
*@package pXP
*@file gen-ACTComisionistas.php
*@author  (admin)
*@date 31-05-2017 20:17:02
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTComisionistas extends ACTbase{    
			
	function listarComisionistas(){
		$this->objParam->defecto('ordenacion','id_comisionista');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODComisionistas','listarComisionistas');
		} else{
			$this->objFunc=$this->create('MODComisionistas');
			
			$this->res=$this->objFunc->listarComisionistas($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarComisionistas(){
		$this->objFunc=$this->create('MODComisionistas');	
		if($this->objParam->insertar('id_comisionista')){
			$this->res=$this->objFunc->insertarComisionistas($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarComisionistas($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarComisionistas(){
			$this->objFunc=$this->create('MODComisionistas');	
		$this->res=$this->objFunc->eliminarComisionistas($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
    function cambiarRevision(){
        $this->objFunc=$this->create('MODComisionistas');
        $this->res=$this->objFunc->cambiarRevision($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());

    }
			
}

?>