<?php
/**
*@package pXP
*@file gen-ACTAjusteDet.php
*@author  (admin)
*@date 10-12-2015 15:16:44
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTAjusteDet extends ACTbase{    
			
	function listarAjusteDet(){
		$this->objParam->defecto('ordenacion','id_ajuste_det');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		
		if($this->objParam->getParametro('id_ajuste')!=''){
			$this->objParam->addFiltro("ajtd.id_ajuste = ".$this->objParam->getParametro('id_ajuste'));	
		}
		
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODAjusteDet','listarAjusteDet');
		} else{
			$this->objFunc=$this->create('MODAjusteDet');
			
			$this->res=$this->objFunc->listarAjusteDet($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarAjusteDet(){
		$this->objFunc=$this->create('MODAjusteDet');	
		if($this->objParam->insertar('id_ajuste_det')){
			$this->res=$this->objFunc->insertarAjusteDet($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarAjusteDet($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarAjusteDet(){
			$this->objFunc=$this->create('MODAjusteDet');	
		$this->res=$this->objFunc->eliminarAjusteDet($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

   function cambiarRevision(){
		$this->objFunc=$this->create('MODAjusteDet');	
		$this->res=$this->objFunc->cambiarRevision($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}


			
}

?>