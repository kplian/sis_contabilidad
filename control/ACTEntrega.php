<?php
/**
*@package pXP
*@file gen-ACTEntrega.php
*@author  (admin)
*@date 17-11-2016 19:50:19
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTEntrega extends ACTbase{    
			
	function listarEntrega(){
		$this->objParam->defecto('ordenacion','id_entrega');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		
		if($this->objParam->getParametro('id_depto')!=''){
			$this->objParam->addFiltro("ent.id_depto_conta = ".$this->objParam->getParametro('id_depto'));	
		}
		
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODEntrega','listarEntrega');
		} else{
			$this->objFunc=$this->create('MODEntrega');
			
			$this->res=$this->objFunc->listarEntrega($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarEntrega(){
		$this->objFunc=$this->create('MODEntrega');	
		if($this->objParam->insertar('id_entrega')){
			$this->res=$this->objFunc->insertarEntrega($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarEntrega($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarEntrega(){
		$this->objFunc=$this->create('MODEntrega');	
		$this->res=$this->objFunc->eliminarEntrega($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function crearEntrega(){
		$this->objFunc=$this->create('MODEntrega');	
		$this->res=$this->objFunc->crearEntrega($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function cambiarEstado(){
		$this->objFunc=$this->create('MODEntrega');	
		$this->res=$this->objFunc->cambiarEstado($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}		
}
?>