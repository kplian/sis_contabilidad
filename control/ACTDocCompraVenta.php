<?php
/**
*@package pXP
*@file gen-ACTDocCompraVenta.php
*@author  (admin)
*@date 18-08-2015 15:57:09
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTDocCompraVenta extends ACTbase{    
			
	function listarDocCompraVenta(){
		$this->objParam->defecto('ordenacion','id_doc_compra_venta');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODDocCompraVenta','listarDocCompraVenta');
		} else{
			$this->objFunc=$this->create('MODDocCompraVenta');
			
			$this->res=$this->objFunc->listarDocCompraVenta($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarDocCompraVenta(){
		$this->objFunc=$this->create('MODDocCompraVenta');	
		if($this->objParam->insertar('id_doc_compra_venta')){
			$this->res=$this->objFunc->insertarDocCompraVenta($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarDocCompraVenta($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarDocCompraVenta(){
			$this->objFunc=$this->create('MODDocCompraVenta');	
		$this->res=$this->objFunc->eliminarDocCompraVenta($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>