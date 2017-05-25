<?php
/**
*@package pXP
*@file gen-ACTTipoDocCompraVenta.php
*@author  (admin)
*@date 22-02-2016 16:19:51
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTTipoDocCompraVenta extends ACTbase{    
			
	function listarTipoDocCompraVenta(){
		$this->objParam->defecto('ordenacion','id_tipo_doc_compra_venta');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('tipo')!=''){
            $this->objParam->addFiltro("tdoc.tipo = ''".$this->objParam->getParametro('tipo')."''");    
        }
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTipoDocCompraVenta','listarTipoDocCompraVenta');
		} else{
			$this->objFunc=$this->create('MODTipoDocCompraVenta');
			
			$this->res=$this->objFunc->listarTipoDocCompraVenta($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarTipoDocCompraVenta(){
		$this->objFunc=$this->create('MODTipoDocCompraVenta');	
		if($this->objParam->insertar('id_tipo_doc_compra_venta')){
			$this->res=$this->objFunc->insertarTipoDocCompraVenta($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarTipoDocCompraVenta($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarTipoDocCompraVenta(){
			$this->objFunc=$this->create('MODTipoDocCompraVenta');	
		$this->res=$this->objFunc->eliminarTipoDocCompraVenta($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>