<?php
/**
*@package pXP
*@file gen-ACTTipoEstadoColumna.php
*@author  (admin)
*@date 26-07-2017 21:49:56
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTTipoEstadoColumna extends ACTbase{    
			
	function listarTipoEstadoColumna(){
		$this->objParam->defecto('ordenacion','id_tipo_estado_columna');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_tipo_estado_cuenta')!=''){
	    	$this->objParam->addFiltro("tecc.id_tipo_estado_cuenta = ".$this->objParam->getParametro('id_tipo_estado_cuenta'));	
		}
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTipoEstadoColumna','listarTipoEstadoColumna');
		} else{
			$this->objFunc=$this->create('MODTipoEstadoColumna');
			
			$this->res=$this->objFunc->listarTipoEstadoColumna($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarTipoEstadoColumna(){
		$this->objFunc=$this->create('MODTipoEstadoColumna');	
		if($this->objParam->insertar('id_tipo_estado_columna')){
			$this->res=$this->objFunc->insertarTipoEstadoColumna($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarTipoEstadoColumna($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarTipoEstadoColumna(){
			$this->objFunc=$this->create('MODTipoEstadoColumna');	
		$this->res=$this->objFunc->eliminarTipoEstadoColumna($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>