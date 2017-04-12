<?php
/**
*@package pXP
*@file gen-ACTAgrupadorDoc.php
*@author  (admin)
*@date 22-09-2015 16:48:19
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTAgrupadorDoc extends ACTbase{    
			
	function listarAgrupadorDoc(){
		$this->objParam->defecto('ordenacion','id_agrupador_doc');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_agrupador')!=''){
            $this->objParam->addFiltro("agd.id_agrupador = ".$this->objParam->getParametro('id_agrupador'));    
        }
		
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODAgrupadorDoc','listarAgrupadorDoc');
		} else{
			$this->objFunc=$this->create('MODAgrupadorDoc');
			
			$this->res=$this->objFunc->listarAgrupadorDoc($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarAgrupadorDoc(){
		$this->objFunc=$this->create('MODAgrupadorDoc');	
		if($this->objParam->insertar('id_agrupador_doc')){
			$this->res=$this->objFunc->insertarAgrupadorDoc($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarAgrupadorDoc($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarAgrupadorDoc(){
			$this->objFunc=$this->create('MODAgrupadorDoc');	
		$this->res=$this->objFunc->eliminarAgrupadorDoc($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function generarCbte(){
		$this->objFunc=$this->create('MODAgrupadorDoc');	
		$this->res=$this->objFunc->generarCbte($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>