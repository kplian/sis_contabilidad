<?php
/**
*@package pXP
*@file gen-ACTIntTransaccion.php
*@author  (admin)
*@date 01-09-2013 18:10:12
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTIntTransaccion extends ACTbase{    
			
	function listarIntTransaccion(){
		$this->objParam->defecto('ordenacion','id_int_transaccion');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_int_comprobante')!=''){
			$this->objParam->addFiltro("transa.id_int_comprobante = ".$this->objParam->getParametro('id_int_comprobante'));	
		}
		if($this->objParam->getParametro('id_moneda')!=''){
			$this->objParam->addFiltro("tval.id_moneda = ".$this->objParam->getParametro('id_moneda'));	
		}
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODIntTransaccion','listarIntTransaccion');
		} else{
			$this->objFunc=$this->create('MODIntTransaccion');
			
			$this->res=$this->objFunc->listarIntTransaccion($this->objParam);
		}
		//adicionar una fila al resultado con el summario
		$temp = Array();
		$temp['importe_debe'] = $this->res->extraData['total_debe'];
		$temp['importe_haber'] = $this->res->extraData['total_haber'];
		$temp['tipo_reg'] = 'summary';
		$temp['id_int_transaccion'] = 0;
		
		$this->res->total++;
		
		$this->res->addLastRecDatos($temp);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarIntTransaccion(){
		$this->objFunc=$this->create('MODIntTransaccion');	
		if($this->objParam->insertar('id_int_transaccion')){
			$this->res=$this->objFunc->insertarIntTransaccion($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarIntTransaccion($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarIntTransaccion(){
			$this->objFunc=$this->create('MODIntTransaccion');	
		$this->res=$this->objFunc->eliminarIntTransaccion($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>