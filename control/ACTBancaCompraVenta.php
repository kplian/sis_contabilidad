<?php
/**
*@package pXP
*@file gen-ACTBancaCompraVenta.php
*@author  (favio figueroa)
*@date 11-09-2015 14:36:46
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTBancaCompraVenta extends ACTbase{    
			
	function listarBancaCompraVenta(){
		$this->objParam->defecto('ordenacion','id_banca_compra_venta');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		
		$this->objParam->addFiltro("confmo.tipo = ''Modalidad de transacción''
                        and conftt.tipo = ''Tipo de transacción''
                        and conftd.tipo = ''Tipo de documento de pago'' ");
						
		if($this->objParam->getParametro('tipo') != ''){
			$this->objParam->addFiltro("banca.tipo = ''".$this->objParam->getParametro('tipo')."'' ");  
			
			
						
		}
		if($this->objParam->getParametro('id_periodo') != ''){
			$this->objParam->addFiltro("banca.id_periodo = ".$this->objParam->getParametro('id_periodo'));  
		}
		
		
		
		if($this->objParam->getParametro('autorizacion') != ''){
			$this->objParam->addFiltro("banca.autorizacion = ".$this->objParam->getParametro('autorizacion'));  
		}
		
		
		/*if($this->objParam->getParametro('id_contrato') != ''){
			$this->objParam->addFiltro("banca.id_contrato = ".$this->objParam->getParametro('id_contrato'));  
		}*/
		
		
		
		if($this->objParam->getParametro('acumulado') == 'si'){
			$this->objParam->addFiltro("banca.id_contrato = ".$this->objParam->getParametro('id_contrato'));  
			
		}
		
		if($this->objParam->getParametro('id_depto') != ''){
			$this->objParam->addFiltro("banca.id_depto_conta = ".$this->objParam->getParametro('id_depto'));  
			
		}
		
		
		if($this->objParam->getParametro('resolucion') != ''){
			$this->objParam->addFiltro("banca.resolucion = ''".$this->objParam->getParametro('resolucion')."'' ");  
			
		}
		
		
		
		
		
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODBancaCompraVenta','listarBancaCompraVenta');
		} else{
			$this->objFunc=$this->create('MODBancaCompraVenta');
			
			$this->res=$this->objFunc->listarBancaCompraVenta($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarBancaCompraVenta(){
		$this->objFunc=$this->create('MODBancaCompraVenta');	
		if($this->objParam->insertar('id_banca_compra_venta')){
			$this->res=$this->objFunc->insertarBancaCompraVenta($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarBancaCompraVenta($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarBancaCompraVenta(){
			$this->objFunc=$this->create('MODBancaCompraVenta');	
		$this->res=$this->objFunc->eliminarBancaCompraVenta($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function cambiarRevision(){
		$this->objFunc=$this->create('MODBancaCompraVenta');	
		$this->res=$this->objFunc->cambiarRevision($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
		
	}

	function importar_txt(){
		
		$this->objFunc=$this->create('MODBancaCompraVenta');	
		$this->res=$this->objFunc->importar_txt($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function exporta_txt(){
		
		
		
		$this->objParam->defecto('ordenacion','id_banca_compra_venta');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		$this->objParam->addFiltro("banca.tipo = ''".$this->objParam->getParametro('tipo')."'' ");  
		$this->objParam->addFiltro("banca.id_periodo = ''".$this->objParam->getParametro('id_periodo')."'' ");
		$this->objParam->addFiltro("banca.revisado = ''si'' ");
		
		$this->objParam->addFiltro("confmo.tipo = ''Modalidad de transacción''
                        and conftt.tipo = ''Tipo de transacción''
                        and conftd.tipo = ''Tipo de documento de pago'' ");
						
		
		$this->objFunc=$this->create('MODBancaCompraVenta');
		$this->res=$this->objFunc->listarBancaCompraVenta($this->objParam);
		
		$datos = $this->res->getDatos();
	
	
		$this->objParam->defecto('dir_ordenacion','asc');
		$this->objParam->parametros_consulta['filtro'] = ' 0 = 0 ';
		$this->objParam->parametros_consulta['ordenacion'] = 'id_empresa';
		$this->objFunc2=$this->create('sis_parametros/MODEmpresa');
		$this->res2=$this->objFunc2->listarEmpresa($this->objParam);
		$empresa = $this->res2->getDatos();
		
		
		$this->objFunc2=$this->create('MODBancaCompraVenta');
		$this->res2=$this->objFunc2->listarPeriodoGestion($this->objParam);
		$periodo_gestion = $this->res2;
		
		$periodo = $periodo_gestion[0]['periodo'];
		$gestion = $periodo_gestion[0]['gestion'];
		

		
		if($periodo < 10){
			$periodo = "0".$periodo;
			
	
		}
		
		$nit_empresa = $empresa[0]['nit'];
		$tipo = $this->objParam->getParametro('tipo');
		
		
		
		$MiDocumento = fopen("../../../reportes_generados/".$tipo."_Auxiliar_".$periodo.$gestion."_".$nit_empresa.".txt", "w+");
		$nombre_archivo = $tipo."_Auxiliar_".$periodo.$gestion."_".$nit_empresa;
		
		
		
		foreach ($datos as $dato) {
			if($this->objParam->getParametro('tipo') == 'Compras'){
				
				$Escribo = "".$dato['modalidad_transaccion'] ."|"
							.$dato['fecha_documento'] ."|"
							.$dato['tipo_transaccion'] ."|"
							.$dato['nit_ci'] ."|"
							.$dato['razon'] ."|"
							.$dato['num_documento'] ."|"
							.$dato['num_contrato'] ."|"
							.$dato['importe_documento'] ."|"
							.$dato['autorizacion'] ."|"
							.$dato['num_cuenta_pago'] ."|"
							.$dato['monto_pagado'] ."|"
							.$dato['monto_acumulado'] ."|"
							.$dato['nit_entidad'] ."|"
							.$dato['num_documento_pago'] ."|"
							.$dato['tipo_documento_pago']."|"
							.$dato['fecha_de_pago'] ."|";
				
			}else if($this->objParam->getParametro('tipo') == 'Ventas'){
				
				$Escribo = "".$dato['modalidad_transaccion'] ."|".$dato['fecha_documento'] ."|".$dato['num_documento'] ."|".$dato['importe_documento'] ."|".$dato['num_contrato'] ."|".$dato['autorizacion'] ."|".$dato['nit_ci'] ."|".$dato['razon'] ."|".$dato['num_cuenta_pago'] ."|".$dato['monto_pagado'] ."|".$dato['monto_acumulado'] ."|".$dato['nit_entidad'] ."|".$dato['num_documento_pago'] ."|".$dato['tipo_documento_pago'] ."|".$dato['fecha_de_pago'] ."| ";				
			}
	
			fwrite($MiDocumento, $Escribo);
			fwrite($MiDocumento, chr(13).chr(10)); //genera el salto de linea
			
		
		}
		fclose($MiDocumento);
		
		$this->res->setDatos($nombre_archivo);
		$this->res->imprimirRespuesta($this->res->generarJson());
		
		
		
			
		//$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function listarDocumento(){
		
		
		
		if($_SESSION["BANCA_DOCUMENTOS"] == NULL){
			
			if($this->objParam->getParametro('sw_libro_compras') != ''){
			$this->objParam->addFiltro("pla.sw_libro_compras = ''".$this->objParam->getParametro('sw_libro_compras')."'' ");  
			}
			
			if($this->objParam->getParametro('nro_nit') != ''){
			$this->objParam->addFiltro("doc.nro_nit = ''".$this->objParam->getParametro('nro_nit')."'' ");  
			}
			
		}
		
		
		
		
		
		$this->objFunc=$this->create('MODBancaCompraVenta');	
		$this->res=$this->objFunc->listarDocumento($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function insertAuto(){
		$this->objFunc=$this->create('MODBancaCompraVenta');	
		$this->res=$this->objFunc->insertAuto($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	function BorrarTodo(){
		$this->objFunc=$this->create('MODBancaCompraVenta');	
		$this->res=$this->objFunc->BorrarTodo($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	function agregarListarNegra(){
		$this->objFunc=$this->create('MODBancaCompraVenta');	
		$this->res=$this->objFunc->agregarListarNegra($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}



			
}

?>