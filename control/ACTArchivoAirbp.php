<?php
/**
*@package pXP
*@file gen-ACTArchivoAirbp.php
*@author  (gsarmiento)
*@date 12-01-2017 21:44:52
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

include_once(dirname(__FILE__).'/../../lib/lib_general/ExcelInput.php');

class ACTArchivoAirbp extends ACTbase{    
			
	function listarArchivoAirbp(){
		$this->objParam->defecto('ordenacion','id_archivo_airbp');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODArchivoAirbp','listarArchivoAirbp');
		} else{
			$this->objFunc=$this->create('MODArchivoAirbp');
			
			$this->res=$this->objFunc->listarArchivoAirbp($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarArchivoAirbp(){
		$this->objFunc=$this->create('MODArchivoAirbp');	
		if($this->objParam->insertar('id_archivo_airbp')){
			$this->res=$this->objFunc->insertarArchivoAirbp($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarArchivoAirbp($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarArchivoAirbp(){
			$this->objFunc=$this->create('MODArchivoAirbp');	
		$this->res=$this->objFunc->eliminarArchivoAirbp($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function subirArchivoAIRBP(){
		$id_int_comprobante = $this->objParam->getParametro('id_int_comprobante');
		$codigoArchivo = $this->objParam->getParametro('codigo');

		$arregloFiles = $this->objParam->getArregloFiles();
		$ext = pathinfo($arregloFiles['archivo']['name']);
		$extension = $ext['extension'];
		$error = 'no';
		$mensaje_completo = '';
		//validar errores unicos del archivo: existencia, copia y extension
		if(isset($arregloFiles['archivo']) && is_uploaded_file($arregloFiles['archivo']['tmp_name'])){

			if (!in_array($extension, array('xls','xlsx','XLS','XLSX'))){
				$mensaje_completo = "La extensión del archivo debe ser XLS o XLSX";
				$error = 'error_fatal';
			}else {
				//procesa Archivo
				$archivoExcel = new ExcelInput($arregloFiles['archivo']['tmp_name'], $codigoArchivo);
				$archivoExcel->recuperarColumnasExcel();

				$arrayArchivo = $archivoExcel->leerColumnasArchivoExcel();
				//var_dump($arrayArchivo); exit;
				$idDocumento=0;
				$importeExcento = 0;		//solo para cobija
				$totalFactura=0;
				foreach ($arrayArchivo as $fila) {

					//$resultLibroCompras;
					$idMoneda=1;
					$nit = 1015497027;
					$razonSocial = 'AIR BP BOLIVIA S.A.';
					$obs = 'Preregistro para AIR BP BOLIVIA';
					$tipo = 'compra';
					$idPlantilla = 1;
					$idDeptoConta = 4;
					$importePendiente = 0;
					$importeAnticipo = 0;
					$importeRetgar = 0;
					$importeIva = 0;
					$importeDescuento = 0;
					$importeDescuentoLey = 0;
					$importePagoLiquido = 0;
					$importeDoc = 0;
					$importeIt = 0;
					$importeNeto = 0;
					$idAuxiliar='';
					$nroDui = '';

					$tokenFactura;
					//$id_comprobante;

					$idFacturaAirbp;
					if($tokenFactura != $fila['nro_documento']){
								$tokenFactura = $fila['nro_documento'];

								//actualiza el total de una factura
								if($idDocumento!=0){
									//calcular iva
									$this->objParam->addParametro('id_doc_compra_venta', $idDocumento);
									$this->objParam->addParametro('importe_excento', $importeExcento);
									$this->objParam->addParametro('importe_iva', $totalFactura-$importeExcento * 0.13);
									$this->objParam->addParametro('importe_pago_liquido', $totalFactura);
									$this->objParam->addParametro('importe_doc', $totalFactura);
									$this->objParam->addParametro('importe_neto', $totalFactura);
									$this->objFunc = $this->create('MODDocCompraVenta');
									$this->res = $this->objFunc->modificarDocCompraVenta($this->objParam);
									//$resultLibroComprasAnt=$Custom->ModificarValorDocumento($idLibroCompras,$id_transaccion,$tipo_documento,$nro_documento,$fecha_documento,$razon_social,$nro_nit,$nro_autorizacion,$codigo_control,$poliza_dui,$formulario,$tipo_retencion,$id_moneda,$importe_credito,$importe_debito,$importe_ice,$importe_it,$importe_iue,$importe_sujeto,$totalFactura,$importeExcento,$estado_documento,$id_comprobante);
									if ($this->res->getTipo() == 'ERROR') {
										$error = 'error';
										$mensaje_completo = "Error al guardar el fila en tabla " . $this->res->getMensajeTec();
										break;
									}
									$totalFactura=0;
									$importeExcento=0;
								}

								$this->objParam->addParametro('fecha', $fila['fecha']);
								$this->objParam->addParametro('nit', $nit);
								$this->objParam->addParametro('nro_autorizacion', $fila['nro_autorizacion']);
								$this->objParam->addParametro('nro_documento', $fila['nro_documento']);
								$this->objParam->addParametro('obs', $obs);
								$this->objParam->addParametro('codigo_control', $fila['codigo_control']);
								$this->objParam->addParametro('razon_social', $razonSocial);
								$this->objParam->addParametro('id_moneda', $idMoneda);
								$this->objParam->addParametro('tipo', $tipo);
								$this->objParam->addParametro('id_plantilla', $idPlantilla);
								$this->objParam->addParametro('id_depto_conta', $idDeptoConta);
								$this->objParam->addParametro('importe_pendiente', $importePendiente);
								$this->objParam->addParametro('importe_anticipo', $importeAnticipo);
								$this->objParam->addParametro('importe_retgar', $importeRetgar);
								$this->objParam->addParametro('nro_dui', $nroDui);
								$this->objParam->addParametro('importe_excento', $importeExcento);
								$this->objParam->addParametro('importe_iva', $importeIva);
								$this->objParam->addParametro('importe_descuento', $importeDescuento);
								$this->objParam->addParametro('importe_descuento_ley', $importeDescuentoLey);
								$this->objParam->addParametro('importe_pago_liquido', $importePagoLiquido);
								$this->objParam->addParametro('importe_doc', $importeDoc);
								$this->objParam->addParametro('importe_it', $importeIt);
								$this->objParam->addParametro('importe_neto', $importeNeto);
								$this->objParam->addParametro('id_auxiliar', $idAuxiliar);

								$this->objFunc = $this->create('MODDocCompraVenta');
								$this->res = $this->objFunc->insertarDocCompraVenta($this->objParam);

								if ($this->res->getTipo() == 'ERROR') {
									$error = 'error';
									$mensaje_completo = "Error al guardar el fila en tabla " . $this->res->getMensajeTec();
									break;
								}
								$datos = $this->res->getDatos();
								$idDocumento = $datos['id_doc_compra_venta'];

								$this->objParam->addParametro('id_doc_compra_venta', $idDocumento);
								$this->objParam->addParametro('id_int_comprobante', $id_int_comprobante);
								$this->res = $this->objFunc->agregarCbteDoc($this->objParam);
								//var_dump($idDocumento); exit;
								//$resultLibroCompras = $Custom -> InsertarRegistroDocumento($id_documento,$id_transaccion,1,$nroFactura,$fechaFactura,'AIR BP BOLIVIA S.A.',1015497027,$numeroAutorizacion,$codigoControl,0,$formulario,$tipo_retencion,$id_moneda,$importe_credito,$importe_debito,0,$importe_it,$importe_iue,$importe_sujeto,$importe_total,0,$estado_documento,'sireli',$importe_descuento,'Preregistro para AIR BP BOLIVIA','no',$id_comprobante);

								/*if($nroFactura == 51 && $fechaFactura =='05/08/2014')
                                {
                                    var_dump($Custom); exit;
                                }*/

								//si ocurre algun error al registrar el libro de compras salta el recorrido
								/*if($Custom->salida[0]=='f'){
									echo 'Falla al ingresar la factura '.$nroFactura. ' emitida en fecha '. $fechaFactura.' \n'.$Custom->salida[1]; exit;
									break;
								}*/
								$this->objParam->addParametro('id_doc_compra_venta', $idDocumento);
								$this->objParam->addParametro('tipo_cambio', $fila['tipo_cambio']);
								$this->objParam->addParametro('punto_venta', $fila['punto_venta']);
								$this->objParam->addParametro('id_cliente', $fila['id_cliente']);
								$this->objParam->addParametro('estado', $fila['estado']);
								$this->objFunc = $this->create('MODFacturaAirbp');
								$this->res = $this->objFunc->insertarFacturaAirbp($this->objParam);

								if ($this->res->getTipo() == 'ERROR') {
									$error = 'error';
									$mensaje_completo = "Error al guardar el fila en tabla " . $this->res->getMensajeTec();
									break;
								}
								$datos = $this->res->getDatos();
								$idFacturaAirbp = $datos['id_factura_airbp'];
								/*
								$idFacturaDetalle = $Custom->salida[2];
								if($Custom->salida[0]=='f'){
									echo 'Falla al ingresar la factura detalle '.$nroFactura. ' del punto de venta '. $puntoVenta; exit;
									break;
								}*/
							}

							$this->objParam->addParametro('id_factura_airbp', $idFacturaAirbp);
							$this->objParam->addParametro('cantidad', $fila['cantidad']);
							$this->objParam->addParametro('total_bs', $fila['total_bs']);
							$this->objParam->addParametro('precio_unitario', $fila['precio_unitario']);
							$this->objParam->addParametro('ne', $fila['ne']);
							$this->objParam->addParametro('destino', $fila['destino']);
							$this->objParam->addParametro('matricula', $fila['matricula']);
							$this->objParam->addParametro('articulo', $fila['articulo']);
							$this->objFunc = $this->create('MODFacturaAirbpConcepto');
							$this->res = $this->objFunc->insertarFacturaAirbpConcepto($this->objParam);

							if ($this->res->getTipo() == 'ERROR') {
								$error = 'error';
								$mensaje_completo = "Error al guardar el fila en tabla " . $this->res->getMensajeTec();
								break;
							}

							//calcula el total de una factura
							if($fila['punto_venta']=='CIJ'){
								$importeExcento = $totalFactura + $fila['total_bs'];				//totalExcento para cobija
								$totalFactura =  $totalFactura + $fila['total_bs'];
							}
							else
								$totalFactura =  $totalFactura + $fila['total_bs'];					//totalFacturas para el resto

				}
				$this->objParam->addParametro('id_doc_compra_venta', $idDocumento);
				$this->objParam->addParametro('importe_excento', $importeExcento);
				$this->objParam->addParametro('importe_iva', ($totalFactura-$importeExcento) * 0.13);
				$this->objParam->addParametro('importe_pago_liquido', $totalFactura);
				$this->objParam->addParametro('importe_doc', $totalFactura);
				$this->objParam->addParametro('importe_neto', $totalFactura);
				$this->objFunc = $this->create('MODDocCompraVenta');
				$this->res = $this->objFunc->modificarDocCompraVenta($this->objParam);
				//$resultLibroComprasAnt=$Custom->ModificarValorDocumento($idLibroCompras,$id_transaccion,$tipo_documento,$nro_documento,$fecha_documento,$razon_social,$nro_nit,$nro_autorizacion,$codigo_control,$poliza_dui,$formulario,$tipo_retencion,$id_moneda,$importe_credito,$importe_debito,$importe_ice,$importe_it,$importe_iue,$importe_sujeto,$totalFactura,$importeExcento,$estado_documento,$id_comprobante);
				if ($this->res->getTipo() == 'ERROR') {
					$error = 'error';
					$mensaje_completo = "Error al guardar el fila en tabla " . $this->res->getMensajeTec();
					break;
				}
			}
			//upload directory
			$upload_dir = "/tmp/";
			//create file name
			$file_path = $upload_dir . $arregloFiles['archivo']['name'];

			//move uploaded file to upload dir
			if (!move_uploaded_file($arregloFiles['archivo']['tmp_name'], $file_path)) {
				//error moving upload file
				$mensaje_completo = "Error al guardar el archivo csv en disco";
				$error = 'error_fatal';
			}
			// }
		} else {
			$mensaje_completo = "No se subio el archivo";
			$error = 'error_fatal';
		}
		//armar respuesta en error fatal
		if ($error == 'error_fatal') {

			$this->mensajeRes=new Mensaje();
			$this->mensajeRes->setMensaje('ERROR','ACTArchivoAirbp.php',$mensaje_completo,
					$mensaje_completo,'control');
			//si no es error fatal proceso el archivo
		} else {
			$lines = file($file_path);
		}
		//armar respuesta en caso de exito o error en algunas tuplas
		if ($error == 'error') {
			$this->mensajeRes=new Mensaje();
			$this->mensajeRes->setMensaje('ERROR','ACTConsumo.php','Ocurrieron los siguientes errores : ' . $mensaje_completo,
					$mensaje_completo,'control');
			/*
            $this->mensajeRes=new Mensaje();
            $this->mensajeRes->setMensaje($this->res);
            $this->mensajeRes->setMensaje($mensaje_completo,$this->nombre_archivo,$this->res->getMensaje(),$this->res->getMensajeTecnico(),'base',$this->res->getProcedimiento(),$this->res->getTransaccion(),$this->res->getTipoProcedimiento,$respuesta['consulta']);
            $this->mensajeRes->setDatos($respuesta);
            $this->res->imprimirRespuesta($this->respuesta->generarJson());
            */
		} else if ($error == 'no') {
			$this->mensajeRes=new Mensaje();
			$this->mensajeRes->setMensaje('EXITO','ACTConsumo.php','El archivo fue ejecutado con éxito',
					'El archivo fue ejecutado con éxito','control');
		}

		//devolver respuesta
		$this->mensajeRes->imprimirRespuesta($this->mensajeRes->generarJson());
	}
}

?>