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
		
		if($this->objParam->getParametro('id_periodo')!=''){
            $this->objParam->addFiltro("dcv.id_periodo = ".$this->objParam->getParametro('id_periodo'));    
        }
		
		if($this->objParam->getParametro('id_int_comprobante')!=''){
            $this->objParam->addFiltro("dcv.id_int_comprobante = ".$this->objParam->getParametro('id_int_comprobante'));    
        }
		
		if($this->objParam->getParametro('tipo')!=''){
            $this->objParam->addFiltro("dcv.tipo = ''".$this->objParam->getParametro('tipo')."''");    
        }
		
		if($this->objParam->getParametro('sin_cbte')=='si'){
            $this->objParam->addFiltro("dcv.id_int_comprobante is NULL");    
        }
		
		if($this->objParam->getParametro('manual')!=''){
            $this->objParam->addFiltro("dcv.manual = ''".$this->objParam->getParametro('manual')."''");    
        }
		
		if($this->objParam->getParametro('fecha_cbte')!=''){
            $this->objParam->addFiltro("dcv.fecha <= ''".$this->objParam->getParametro('fecha_cbte')."''::date");    
        }
		
		
		
		
		if($this->objParam->getParametro('id_depto')!=''){
            $this->objParam->addFiltro("dcv.id_depto_conta = ".$this->objParam->getParametro('id_depto'));    
        }
		
		if($this->objParam->getParametro('id_agrupador')!=''){
            $this->objParam->addFiltro("dcv.id_doc_compra_venta not in (select ad.id_doc_compra_venta from conta.tagrupador_doc ad where ad.id_agrupador = ".$this->objParam->getParametro('id_agrupador').") ");    
        }
		
		
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODDocCompraVenta','listarDocCompraVenta');
		} else{
			$this->objFunc=$this->create('MODDocCompraVenta');
			
			$this->res=$this->objFunc->listarDocCompraVenta($this->objParam);
		}
		
		$temp = Array();
			$temp['importe_ice'] = $this->res->extraData['total_importe_ice'];
			$temp['importe_excento'] = $this->res->extraData['total_importe_excento'];
			$temp['importe_it'] = $this->res->extraData['total_importe_it'];
			$temp['importe_iva'] = $this->res->extraData['total_importe_iva'];
			$temp['importe_descuento'] = $this->res->extraData['total_importe_descuento'];
			$temp['importe_doc'] = $this->res->extraData['total_importe_doc'];			
			$temp['importe_retgar'] = $this->res->extraData['total_importe_retgar'];
			$temp['importe_anticipo'] = $this->res->extraData['total_importe_anticipo'];
			$temp['importe_pendiente'] = $this->res->extraData['tota_importe_pendiente'];
			$temp['importe_neto'] = $this->res->extraData['total_importe_neto'];
			$temp['importe_descuento_ley'] = $this->res->extraData['total_importe_descuento_ley'];
			$temp['importe_pago_liquido'] = $this->res->extraData['tota_importe_pago_liquido'];
			
			$temp['tipo_reg'] = 'summary';
			$temp['id_int_doc_compra_venta'] = 0;
			
			
			
			
			$this->res->total++;
			
			$this->res->addLastRecDatos($temp);
		
		
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function listarNroAutorizacion(){
		$this->objParam->defecto('ordenacion','nro_autorizacion');
        $this->objParam->defecto('dir_ordenacion','asc');		
		$this->objFunc=$this->create('MODDocCompraVenta');
		$this->res=$this->objFunc->listarNroAutorizacion($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	function listarNroNit(){
		$this->objParam->defecto('ordenacion','nit');
        $this->objParam->defecto('dir_ordenacion','asc');		
		$this->objFunc=$this->create('MODDocCompraVenta');
		$this->res=$this->objFunc->listarNroNit($this->objParam);
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
	
	/*
	 * Author:  		 RAC - KPLIAN
	 * Date:   			 04/02/2015
	 * Description		 insertar documentos de compra o venta con su detalle de conceptos
	 * */
	
	function insertarDocCompleto(){
		$this->objFunc=$this->create('MODDocCompraVenta');	
		if($this->objParam->insertar('id_doc_compra_venta')){
			$this->res=$this->objFunc->insertarDocCompleto($this->objParam);			
		} else{
			//TODO			
			//$this->res=$this->objFunc->modificarSolicitud($this->objParam);
			//trabajar en la modificacion compelta de solicitud ....
			$this->res=$this->objFunc->modificarDocCompleto($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
		
						
	function eliminarDocCompraVenta(){
		$this->objFunc=$this->create('MODDocCompraVenta');	
		$this->res=$this->objFunc->eliminarDocCompraVenta($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function cambiarRevision(){
		$this->objFunc=$this->create('MODDocCompraVenta');	
		$this->res=$this->objFunc->cambiarRevision($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function quitarCbteDoc(){
		$this->objFunc=$this->create('MODDocCompraVenta');	
		$this->res=$this->objFunc->quitarCbteDoc($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function agregarCbteDoc(){
		$this->objFunc=$this->create('MODDocCompraVenta');	
		$this->res=$this->objFunc->agregarCbteDoc($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	
			
}

?>