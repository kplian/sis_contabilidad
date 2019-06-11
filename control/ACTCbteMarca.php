<?php
/**
*@package pXP
*@file gen-ACTCbteMarca.php
*@author  (egutierrez)
*@date 10-06-2019 20:02:44
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTCbteMarca extends ACTbase{    
			
	function listarCbteMarca(){
		$this->objParam->defecto('ordenacion','id_cbte_marca');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		$this->objParam->parametros_consulta['cantidad'] = '10000';
		$this->objParam->parametros_consulta['puntero'] = '0';
		
		if($this->objParam->getParametro('id_int_comprobante')!= '' ){
		    $this->objParam->addFiltro("cbtemar.id_int_comprobante =" . $this->objParam->getParametro('id_int_comprobante')." ");
		};
		//var_dump('hola',$this->objParam);
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCbteMarca','listarCbteMarca');
		} else{
			$this->objFunc=$this->create('MODCbteMarca');
			
			$this->res=$this->objFunc->listarCbteMarca($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarCbteMarca(){
		$this->objFunc=$this->create('MODCbteMarca');
		
	    var_dump('obj',$this->objParam);exit; 	
		if($this->objParam->insertar('id_cbte_marca')){
			$this->res=$this->objFunc->insertarCbteMarca($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarCbteMarca($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarCbteMarca(){
		$this->objFunc=$this->create('MODCbteMarca');	
		$this->res=$this->objFunc->eliminarCbteMarca($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function guardarCbteMarca(){
				
		$this->objFunc=$this->create('MODCbteMarca');		
		$this->res=$this->objFunc->guardarCbteMarca($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
			
}

?>