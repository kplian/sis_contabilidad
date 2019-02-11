<?php
/**
*@package pXP
*@file gen-MODComisionistas.php
*@author  (admin)
*@date 31-05-2017 20:17:02
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODComisionistas extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
        $this->cone = new conexion();
        $this->link = $this->cone->conectarpdo(); //conexion a pxp(postgres)
	}
			
	function listarComisionistas(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_comisionistas_sel';
		$this->transaccion='CONTA_CMS_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_comisionista','int4');
		$this->captura('nit_comisionista','varchar');
		$this->captura('nro_contrato','varchar');
		$this->captura('codigo_producto','varchar');
		$this->captura('descripcion_producto','varchar');
        $this->captura('cantidad_total_entregado','numeric');
        $this->captura('cantidad_total_vendido','numeric');
        $this->captura('precio_unitario','numeric');
        $this->captura('monto_total','numeric');
        $this->captura('monto_total_comision','numeric');
        $this->captura('revisado','varchar');
        $this->captura('id_periodo','int4');
        $this->captura('id_depto_conta','int4');
        $this->captura('registro','varchar');
        $this->captura('tipo_comisionista','varchar');
        $this->captura('lista_negra','varchar');
        $this->captura('gestion','int4');
        $this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');


		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarComisionistas(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_comisionistas_ime';
		$this->transaccion='CONTA_CMS_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
        $this->setParametro('nit_comisionista','nit_comisionista','varchar');
        $this->setParametro('nro_contrato','nro_contrato','varchar');
        $this->setParametro('codigo_producto','codigo_producto','varchar');
        $this->setParametro('descripcion_producto','descripcion_producto','varchar');
        $this->setParametro('cantidad_total_entregado','cantidad_total_entregado','numeric');
        $this->setParametro('cantidad_total_vendido','cantidad_total_vendido','numeric');
        $this->setParametro('precio_unitario','precio_unitario','numeric');
        $this->setParametro('monto_total','monto_total','numeric');
        $this->setParametro('monto_total_comision','monto_total_comision','numeric');
        $this->setParametro('id_periodo','id_periodo','int4');
        $this->setParametro('id_depto_conta','id_depto_conta','int4');
        $this->setParametro('estado_reg','estado_reg','varchar');


		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarComisionistas(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_comisionistas_ime';
		$this->transaccion='CONTA_CMS_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_comisionista','id_comisionista','int4');
        $this->setParametro('nit_comisionista','nit_comisionista','varchar');
        $this->setParametro('nro_contrato','nro_contrato','varchar');
        $this->setParametro('codigo_producto','codigo_producto','varchar');
        $this->setParametro('descripcion_producto','descripcion_producto','varchar');
        $this->setParametro('cantidad_total_entregado','cantidad_total_entregado','numeric');
        $this->setParametro('cantidad_total_vendido','cantidad_total_vendido','numeric');
        $this->setParametro('precio_unitario','precio_unitario','numeric');
        $this->setParametro('monto_total','monto_total','numeric');
        $this->setParametro('monto_total_comision','monto_total_comision','numeric');
        $this->setParametro('id_periodo','id_periodo','int4');
        $this->setParametro('id_depto_conta','id_depto_conta','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarComisionistas(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_comisionistas_ime';
		$this->transaccion='CONTA_CMS_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_comisionista','id_comisionista','int4');
        $this->setParametro('id_periodo','id_periodo','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

    function cambiarRevision(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='conta.ft_comisionistas_ime';
        $this->transaccion='CONTA_REV_IME';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_comisionista','id_comisionista','int4');

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
            /*$nombre_archivo = $arregloFiles['archivo']['name'];
            $partes = explode('_',$nombre_archivo);
            $fecha_archivo = $this->str_osplit($partes[2], 2);
            $fecha_archivo = '01/'.$fecha_archivo[0].'/'.$fecha_archivo[1];
            $this->aParam->addParametro('nombre_archivo', $nombre_archivo);
            $this->arreglo['nombre_archivo'] = $nombre_archivo;
            $this->aParam->addParametro('fecha_archivo', $fecha_archivo);
            $this->arreglo['fecha_archivo'] = $fecha_archivo;
            */
            $lines = file($file_path);
            foreach ($lines as $line_num => $line) {
                $line = str_replace("'","",$line);
                $arr_temp = explode('|', $line);
                $arra[] = array(
                    "nit_comisionista" => $arr_temp[0],
                    "nro_contrato" => $arr_temp[1],
                    "codigo_producto" => $arr_temp[2],
                    "descripcion_producto" => $arr_temp[3],
                    "cantidad_total_entregado" => $arr_temp[4],
                    "cantidad_total_vendido" => $arr_temp[5],
                    "precio_unitario" => $arr_temp[6],
                    "monto_total" => $arr_temp[7],
                    "monto_total_comision" => $arr_temp[8]);

                if (count($arr_temp) != 14) {
                    $error = 'error';
                    $mensaje_completo .= "No se proceso la linea: $line_num, por un error en el formato \n";

                } else {

                }
            }
        }

        $arra_json = json_encode($arra);
        $this->aParam->addParametro('arra_json', $arra_json);
        $this->arreglo['arra_json'] = $arra_json;

        $this->procedimiento='conta.ft_comisionistas_ime';
        $this->transaccion='CONTA_REV_IMP';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('arra_json','arra_json','text');
        $this->setParametro('id_periodo','id_periodo','int4');
        $this->setParametro('id_depto_conta','id_depto_conta','int4');

        $this->setParametro('fecha_archivo','fecha_archivo','date');
        $this->setParametro('nombre_archivo','nombre_archivo','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;

    }
    function BorrarTodo(){

        $this->procedimiento='conta.ft_comisionistas_ime';
        $this->transaccion='CONTA_REV_ELITO';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_depto_conta','id_depto_conta','int4');
        $this->setParametro('id_periodo','id_periodo','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;

    }
    function clonar(){
        $this->procedimiento='conta.ft_comisionistas_ime';
        $this->transaccion='CONTA_REV_CLON';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_comisionista','id_comisionista','int4');


        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    function agregarListarNegra(){
        $this->procedimiento='conta.ft_comisionistas_ime';
        $this->transaccion='CONTA_REV_NEGR';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_comisionista','id_comisionista','int4');
        $this->setParametro('id_periodo','id_periodo','int4');
        $this->setParametro('id_depto_conta','id_depto_conta','int4');


        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    function nitEmpresa(){
        $res = $this->link->prepare("   select em.nit
                                        from param.tempresa em
										");
        $res->execute();
        $result = $res->fetchAll(PDO::FETCH_ASSOC);
        return $result;
    }
}
?>