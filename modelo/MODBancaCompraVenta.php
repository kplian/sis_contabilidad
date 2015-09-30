<?php
/**
*@package pXP
*@file gen-MODBancaCompraVenta.php
*@author  (admin)
*@date 11-09-2015 14:36:46
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODBancaCompraVenta extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
		
		$this->cone = new conexion();
		$this->link = $this->cone->conectarpdo(); //conexion a pxp(postgres)
	}
			
	function listarBancaCompraVenta(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_banca_compra_venta_sel';
		$this->transaccion='CONTA_BANCA_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_banca_compra_venta','int4');
		$this->captura('num_cuenta_pago','varchar');
		$this->captura('tipo_documento_pago','numeric');
		$this->captura('num_documento','varchar');
		$this->captura('monto_acumulado','numeric');
		$this->captura('estado_reg','varchar');
		$this->captura('nit_ci','varchar');
		$this->captura('importe_documento','numeric');
		$this->captura('fecha_documento','date');
		$this->captura('modalidad_transaccion','int4');
		$this->captura('tipo_transaccion','int4');
		$this->captura('autorizacion','numeric');
		$this->captura('monto_pagado','numeric');
		$this->captura('fecha_de_pago','date');
		$this->captura('razon','varchar');
		$this->captura('tipo','varchar');
		$this->captura('num_documento_pago','varchar');
		$this->captura('num_contrato','varchar');
		$this->captura('nit_entidad','numeric');
			
		
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_periodo','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		$this->captura('desc_modalidad_transaccion','varchar');
		$this->captura('desc_tipo_transaccion','varchar');
		$this->captura('desc_tipo_documento_pago','varchar');
		
		$this->captura('revisado','varchar');
		
		

                        
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarBancaCompraVenta(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_banca_compra_venta_ime';
		$this->transaccion='CONTA_BANCA_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('num_cuenta_pago','num_cuenta_pago','varchar');
		$this->setParametro('tipo_documento_pago','tipo_documento_pago','numeric');
		$this->setParametro('num_documento','num_documento','varchar');
		$this->setParametro('monto_acumulado','monto_acumulado','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nit_ci','nit_ci','varchar');
		$this->setParametro('importe_documento','importe_documento','numeric');
		$this->setParametro('fecha_documento','fecha_documento','date');
		$this->setParametro('modalidad_transaccion','modalidad_transaccion','int4');
		$this->setParametro('tipo_transaccion','tipo_transaccion','int4');
		$this->setParametro('autorizacion','autorizacion','numeric');
		$this->setParametro('monto_pagado','monto_pagado','numeric');
		$this->setParametro('fecha_de_pago','fecha_de_pago','date');
		$this->setParametro('razon','razon','varchar');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('num_documento_pago','num_documento_pago','varchar');
		$this->setParametro('num_contrato','num_contrato','varchar');
		$this->setParametro('nit_entidad','nit_entidad','numeric');
		
		$this->setParametro('id_periodo','id_periodo','int4');
		
		$this->setParametro('id_depto_conta','id_depto_conta','int4');
		
	
	

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarBancaCompraVenta(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_banca_compra_venta_ime';
		$this->transaccion='CONTA_BANCA_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_banca_compra_venta','id_banca_compra_venta','int4');
		$this->setParametro('num_cuenta_pago','num_cuenta_pago','varchar');
		$this->setParametro('tipo_documento_pago','tipo_documento_pago','numeric');
		$this->setParametro('num_documento','num_documento','varchar');
		$this->setParametro('monto_acumulado','monto_acumulado','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nit_ci','nit_ci','varchar');
		$this->setParametro('importe_documento','importe_documento','numeric');
		$this->setParametro('fecha_documento','fecha_documento','date');
		$this->setParametro('modalidad_transaccion','modalidad_transaccion','int4');
		$this->setParametro('tipo_transaccion','tipo_transaccion','int4');
		$this->setParametro('autorizacion','autorizacion','numeric');
		$this->setParametro('monto_pagado','monto_pagado','numeric');
		$this->setParametro('fecha_de_pago','fecha_de_pago','date');
		$this->setParametro('razon','razon','varchar');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('num_documento_pago','num_documento_pago','varchar');
		$this->setParametro('num_contrato','num_contrato','varchar');
		$this->setParametro('nit_entidad','nit_entidad','numeric');
		
		$this->setParametro('id_periodo','id_periodo','int4');
		
		$this->setParametro('revisado','revisado','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarBancaCompraVenta(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_banca_compra_venta_ime';
		$this->transaccion='CONTA_BANCA_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_banca_compra_venta','id_banca_compra_venta','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function listarPeriodoGestion(){
		
		
		$id_periodo = $this->objParam->getParametro('id_periodo');
		$res = $this->link->prepare("select per.periodo,ges.gestion from param.tperiodo per
										inner join param.tgestion ges on ges.id_gestion = per.id_gestion
										where per.id_periodo = '$id_periodo' ");
		$res->execute();
		$result = $res->fetchAll(PDO::FETCH_ASSOC);
		return $result;
		
	}
	
	
	function cambiarRevision(){
		
		
		$id_banca_compra_venta = $this->objParam->getParametro('id_banca_compra_venta');
		$revisado = $this->objParam->getParametro('revisado');
		
		$this->procedimiento='conta.ft_verificar_banca_compra_venta';
		$this->transaccion='CONTA_REVISAR_BANCA';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_banca_compra_venta','id_banca_compra_venta','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
		

	}
	
	function importar_txt(){
		
		
			$arra = array();

			$arregloFiles = $this->objParam->getArregloFiles();
			$ext = pathinfo($arregloFiles['archivo']['name']);
			$extension = $ext['extension'];
	
			$error = 'no';
			$mensaje_completo = '';
			//validar errores unicos del archivo: existencia, copia y extension
			if(isset($arregloFiles['archivo']) && is_uploaded_file($arregloFiles['archivo']['tmp_name'])){
				if ($extension != 'txt' && $extension != 'txt') {
					$mensaje_completo = "La extensión del archivo debe ser TXT";
					$error = 'error_fatal';
				}  
		  	    //upload directory  
			    $upload_dir = "/tmp/";  
			    //create file name  
			    $file_path = $upload_dir . $arregloFiles['archivo']['name'];  
			  	
			    //move uploaded file to upload dir  
			    if (!move_uploaded_file($arregloFiles['archivo']['tmp_name'], $file_path)) {	  
			        //error moving upload file  
			        $mensaje_completo = "Error al guardar el archivo txt en disco";
					$error = 'error_fatal';	  
			    }  
				
			} else {
				$mensaje_completo = "No se subio el archivo";
				$error = 'error_fatal';
			}
			
			//armar respuesta en error fatal
			if ($error == 'error_fatal') {
				
				$this->mensajeRes=new Mensaje();
				$this->mensajeRes->setMensaje('ERROR','ATCBancaCompraVenta.php',$mensaje_completo,
											$mensaje_completo,'control');
			//si no es error fatal proceso el archivo
			} else {
				$lines = file($file_path);
				
				
				foreach ($lines as $line_num => $line) {
					$arr_temp = explode('|', $line);
					
					
					if($this->aParam->getParametro('tipo')=='Compras'){
						$arra[] = array(
							"modalidad_transaccion" => $arr_temp[0],
       						"fecha_documento" => $arr_temp[1],
       						"tipo_transaccion" => $arr_temp[2],
       						"nit_ci" => $arr_temp[3],
       						"razon" => $arr_temp[4],
       						"num_documento" => $arr_temp[5],
       						"num_contrato" => $arr_temp[6],
       						"importe_documento" => $arr_temp[7],
       						"autorizacion" => $arr_temp[8],
       						"num_cuenta_pago" => $arr_temp[9],
       						"monto_pagado" => $arr_temp[10],
       						"monto_acumulado" => $arr_temp[11],
       						"nit_entidad" => $arr_temp[12],
       						"num_documento_pago" => $arr_temp[13],
       						"tipo_documento_pago" => $arr_temp[14],
       						"fecha_de_pago" => $arr_temp[15],
       						
						);
					}else if($this->aParam->getParametro('tipo')=='Ventas'){
						$arra[] = array(
							"modalidad_transaccion" => $arr_temp[0],
       						"fecha_documento" => $arr_temp[1],
       						"tipo_transaccion" => $arr_temp[2],
       						"nit_ci" => $arr_temp[3],
       						"razon" => $arr_temp[4],
       						"num_documento" => $arr_temp[5],
       						"num_contrato" => $arr_temp[6],
       						"importe_documento" => $arr_temp[7],
       						"autorizacion" => $arr_temp[8],
       						"num_cuenta_pago" => $arr_temp[9],
       						"monto_pagado" => $arr_temp[10],
       						"monto_acumulado" => $arr_temp[11],
       						"nit_entidad" => $arr_temp[12],
       						"num_documento_pago" => $arr_temp[13],
       						"tipo_documento_pago" => $arr_temp[14],
       						"fecha_de_pago" => $arr_temp[15],
       						
						);
					}
					
					
					
					if (count($arr_temp) != 16) {
						$error = 'error';
						$mensaje_completo .= "No se proceso la linea: $line_num, por un error en el formato \n";
						
					} else {
						
						
						
						/*$this->objParam->addParametro('ci',$arr_temp[0]);
						$this->objParam->addParametro('valor',$arr_temp[1]);
						$this->objFunc=$this->create('MODColumnaValor');
						$this->res=$this->objFunc->modificarColumnaCsv($this->objParam);
						if ($this->res->getTipo() == 'ERROR') {
							$error = 'error';
							$mensaje_completo .= $this->res->getMensaje() . " \n";
						}*/
					}
				}
			}
			
			
		
			$arra_json = json_encode($arra);
		
			$this->aParam->addParametro('arra_json', $arra_json);
			$this->arreglo['arra_json'] = $arra_json;
			
			
			$this->procedimiento='conta.ft_banca_compra_venta_ime';
			$this->transaccion='CONTA_BANCA_IMP';
			$this->tipo_procedimiento='IME';
					
			//Define los parametros para la funcion
			$this->setParametro('arra_json','arra_json','text');
			$this->setParametro('tipo','tipo','varchar');
			$this->setParametro('id_periodo','id_periodo','int4');
	
			//Ejecuta la instruccion
			$this->armarConsulta();
			$this->ejecutarConsulta();
	
			//Devuelve la respuesta
			return $this->respuesta;
			
			
			
			
		
	}
	
			
}
?>