<?php
/**
*@package pXP
*@file gen-MODRegimenSimplificado.php
*@author  (admin)
*@date 31-05-2017 20:17:05
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODRegimenSimplificado extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);

        $this->cone = new conexion();
        $this->link = $this->cone->conectarpdo(); //conexion a pxp(postgres)
	}
			
	function listarRegimenSimplificado(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_regimen_simplificado_sel';
		$this->transaccion='CONTA_RSO_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_simplificado','int4');
        $this->captura('codigo_cliente','varchar');
        $this->captura('nit','varchar');
        $this->captura('codigo_producto','varchar');
        $this->captura('descripcion','varchar');
        $this->captura('cantidad_producto','numeric');
		$this->captura('precio_unitario','numeric');
        $this->captura('importe_total','numeric');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
        $this->captura('revisado','varchar');
        $this->captura('id_periodo','int4');
        $this->captura('id_depto_conta','int4');
        $this->captura('registro','varchar');
        $this->captura('tipo_regimen_simplificado','varchar');
        $this->captura('lista_negra','varchar');
        $this->captura('gestion','int4');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarRegimenSimplificado(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_regimen_simplificado_ime';
		$this->transaccion='CONTA_RSO_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('precio_unitario','precio_unitario','numeric');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('codigo_cliente','codigo_cliente','varchar');
		$this->setParametro('codigo_producto','codigo_producto','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('importe_total','importe_total','numeric');
		$this->setParametro('cantidad_producto','cantidad_producto','int4');
		$this->setParametro('nit','nit','varchar');
        $this->setParametro('id_periodo','id_periodo','int4');
        $this->setParametro('id_depto_conta','id_depto_conta','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarRegimenSimplificado(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_regimen_simplificado_ime';
		$this->transaccion='CONTA_RSO_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_simplificado','id_simplificado','int4');
		$this->setParametro('precio_unitario','precio_unitario','numeric');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('codigo_cliente','codigo_cliente','varchar');
		$this->setParametro('codigo_producto','codigo_producto','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('importe_total','importe_total','numeric');
		$this->setParametro('cantidad_producto','cantidad_producto','int4');
		$this->setParametro('nit','nit','varchar');
        $this->setParametro('id_periodo','id_periodo','int4');
        $this->setParametro('id_depto_conta','id_depto_conta','int4');



		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarRegimenSimplificado(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_regimen_simplificado_ime';
		$this->transaccion='CONTA_RSO_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_simplificado','id_simplificado','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
    function cambiarRevision(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='conta.ft_regimen_simplificado_ime';
        $this->transaccion='CONTA_REV_IME';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_simplificado','id_simplificado','int4');

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
            //$nombre_archivo = $arregloFiles['archivo']['name'];
            //$partes = explode('_',$nombre_archivo);
            //$fecha_archivo = $this->str_osplit($partes[2], 2);
            //$fecha_archivo = '01/'.$fecha_archivo[0].'/'.$fecha_archivo[1];
            //$this->aParam->addParametro('nombre_archivo', $nombre_archivo);
            //$this->arreglo['nombre_archivo'] = $nombre_archivo;
           // $this->aParam->addParametro('fecha_archivo', $fecha_archivo);
            //$this->arreglo['fecha_archivo'] = $fecha_archivo;
            $lines = file($file_path);
            foreach ($lines as $line_num => $line) {
                $line = str_replace("'","",$line);
                $arr_temp = explode('|', $line);
                //$arr_temp = $this->remove_utf8_bom($arr_temp);
                 $arra[] = array(
                     "precio_unitario" => $arr_temp[0],
                     "descripcion" => $arr_temp[1],
                     "codigo_cliente" => $arr_temp[2],
                     "codigo_producto" => $arr_temp[3],
                     "importe_total" => $arr_temp[4],
                     "cantidad_producto" => $arr_temp[5],
                     "nit" => $arr_temp[6]);
                if (count($arr_temp) != 7) {
                    $error = 'error';
                    $mensaje_completo .= "No se proceso la linea: $line_num, por un error en el formato \n";

                } else {

                }
            }
        }

        $arra_json = json_encode($arra);
        $this->aParam->addParametro('arra_json', $arra_json);
        $this->arreglo['arra_json'] = $arra_json;

        $this->procedimiento='conta.ft_regimen_simplificado_ime';
        $this->transaccion='CONTA_RSO_IMP';
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

        $this->procedimiento='conta.ft_regimen_simplificado_ime';
        $this->transaccion='CONTA_RSO_ELITO';
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
        $this->procedimiento='conta.ft_regimen_simplificado_ime';
        $this->transaccion='CONTA_RSO_CLON';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_simplificado','id_simplificado','int4');



        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    function agregarListarNegra(){
        $this->procedimiento='conta.ft_regimen_simplificado_ime';
        $this->transaccion='CONTA_RSO_NEGR';
        $this->tipo_procedimiento='IME';
        //Define los parametros para la funcion
        $this->setParametro('id_simplificado','id_simplificado','int4');
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