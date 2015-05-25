<?php  
  $cabecera = $dataSource->getParameter('cabecera');
  $detalleCbte = $dataSource->getParameter('detalleCbte');
?>
<html>
	 <head></head>
<body>
	
	<table width="100%" style="width: 100%; text-align: center;" cellspacing="0" cellpadding="1" border="1">
	<tbody><tr>
		<!--<td width="23%" rowspan="4"><img  border="0" src="../imagenes/logos/logo.jpg"></td>-->
		<td style="width: 23%; color: #444444;" rowspan="4">
			<img  style="width: 150px;" src="./../../../lib/imagenes/logos/logo.jpg" alt="Logo">
		</td>		
		<td style="width: 54%; color: #444444;" rowspan="2"><h1><?php  echo $cabecera[0]['desc_clase_comprobante']; ?> </h1></td>
		<td style="width: 23%; color: #444444;"><b>Depto.:</b> <?php  echo $cabecera[0]['codigo_depto']; ?> </td>
	</tr>
	<tr>
		<td style="width: 23%; color: #444444;"><b>N°:</b> <?php  echo $cabecera[0]['nro_cbte']; ?> </td>
	</tr>
	<tr>
		<td style="width: 54%; color: #444444;" rowspan="2"></td>
		<td style="width: 23%; color: #444444;"><b>Fecha:</b> <?php  echo $cabecera[0]['fecha']; ?></td>
	</tr>
	<tr>
		<td style="width: 23%; color: #444444;"><b>Moneda</b> <?php  echo $cabecera[0]['desc_moneda']; ?> </td>
	</tr>
</tbody></table>
<br>
<br>

<table width="100%" cellspacing="1" cellpadding="1" border="0">
	
		<tr>
			<td><b>Beneficiario:</b>&nbsp;&nbsp;&nbsp;&nbsp;  <?php  echo $cabecera[0]['beneficiario']; ?></td>
		</tr>
		
		<tr>
			<td><b>Glosa:</b>&nbsp;&nbsp;&nbsp;&nbsp; <?php  echo $cabecera[0]['glosa1'].'<br>'.$cabecera[0]['glosa2']; ?></td>
		</tr>
		<?php 
		  if ($cabecera[0]['id_moneda'] != $cabecera[0]['id_moneda_base']){
		 ?>
			
		<tr>
			<td><b>T/C:</b> &nbsp;&nbsp;&nbsp;&nbsp;<?php  echo $cabecera[0]['tipo_cambio']; ?></td>
		</tr>
		
		<?php } ?>
</table>
<br>
<br>
<?php   
	if ($cabecera[0]['id_moneda'] == $cabecera[0]['id_moneda_base']){
		$with_col = '60%';
	}
	else{
		$with_col = '50%';
	}

?>

<table width="100%" cellpadding="5px"  rules="cols" border="1">
	<tbody>
		
		<?php 
		  if ($cabecera[0]['id_moneda'] == $cabecera[0]['id_moneda_base']){
		 ?>
		<tr>
			<td width="60%" rowspan="2" align="center" >DETALLE</td>
			<td width="40%" colspan="2"  align="center" class="td_currency"><span><?php  echo $cabecera[0]['desc_moneda']; ?></span></td>
		</tr>
		<tr>
			<td width="20%" align="center" class="td_currency"><span>DEBE</span></td>
			<td width="20%" align="center" class="td_currency"><span>HABER</span></td>
		</tr>
<?php	}
		else{  ?>
		<tr>
			<td width="50%" rowspan="2" align="center" >DETALLE</td>
			<td width="25%" colspan="2"  align="center" class="td_currency"><span><?php  echo $cabecera[0]['desc_moneda']; ?></span></td>
			<td width="25%" colspan="2"  align="center" class="td_currency"><span>BS</span></td>
		
		</tr>
		<tr>
			<td width="12.5%" align="center" class="td_currency"><span>DEBE</span></td>
			<td width="12.5%" align="center" class="td_currency"><span>HABER</span></td>
			<td width="12.5%" align="center" class="td_currency"><span>DEBE</span></td>
			<td width="12.5%" align="center" class="td_currency"><span>HABER</span></td>
		</tr>
			
		<?php } ?>
		
		<?php 
		   $tot_debe = 0;
		   $tot_haber = 0;
		   foreach($detalleCbte as $key=>$val){     ?>
		<tr>
		    <td width="<?php  echo $with_col; ?>" ><div>
				<b>CC:</b> <?php  echo  $val['cc']; ?> <br/>
			<?php if  ($val['codigo_partida']!=''){ ?>	
	   			<b>Ptda.:</b> <?php  echo $val['codigo_partida'].'-'.$val['nombre_partida']; ?><br/>
	   		<?php } ?>		
	   			<b>Cta.:</b> <?php  echo $val['codigo_cuenta'].' - '.$val['nombre_cuenta']; ?><br/>
	   			<b>Aux.:</b> <?php  echo $val['codigo_auxiliar'].' - '.$val['nombre_auxiliar']; ?><br/>
	   		<?php if  ($val['desc_orden']!=''){ ?>	
	   			<b>OT.:</b> <?php  echo $val['desc_orden']; ?><br>
	   		<?php } ?>	
	   		    <b><?php  echo $val['glosa']; ?></b></div>
			</td>
			
		<?php 
		  if ($cabecera[0]['id_moneda'] == $cabecera[0]['id_moneda_base']){
		 ?>
			
			<td width="20%" align="right" class="td_currency"><span><?php  if ($val['importe_debe']>0) {echo  $val['importe_debe'];} ?></span></td>
			<td width="20%" align="right" class="td_currency"><span><?php  if ($val['importe_haber']>0) {echo  $val['importe_haber'];} ?></span></td>
		<?php	
		  }
		 else{  
		?>
		    <td width="12.5%" align="right" class="td_currency"><span><?php  if ($val['importe_debe']>0) {echo  $val['importe_debe']; }?></span></td>
			<td width="12.5%" align="right" class="td_currency"><span><?php  if ($val['importe_haber']>0) {echo  $val['importe_haber'];} ?></span></td>
			<td width="12.5%" align="right" class="td_currency"><span><?php  if ($val['importe_debe_mb']>0) {echo  $val['importe_debe_mb'];} ?></span></td>
			<td width="12.5%" align="right" class="td_currency"><span><?php  if ($val['importe_haber_mb']>0) {echo  $val['importe_haber_mb'];} ?></span></td>
		
		<?php } ?>
		</tr>
		<?php  
		    $tot_debe+=$val['importe_debe'];
			$tot_haber+=$val['importe_haber'];
			$tot_debe_mb+=$val['importe_debe_mb'];
			$tot_haber_mb+=$val['importe_haber_mb'];
		
		
		} ?>
		
		<tr>
			<td width="<?php  echo $with_col; ?>" align="right"><b>TOTALES&nbsp;&nbsp;&nbsp;&nbsp;</b></td>	
		<?php 
		  if ($cabecera[0]['id_moneda'] == $cabecera[0]['id_moneda_base']){
		 ?>
			
			<td width="20%" align="right" class="td_currency"><span><b><?php  if ($tot_debe>0) { echo $tot_debe;} ?></b></span></td>
			<td width="20%" align="right" class="td_currency"><span><b><?php  if ($tot_haber>0) {echo $tot_haber;} ?></b></span></td>
		<?php	
		  }
		 else{  
		?>
		    <td width="12.5%" align="right" class="td_currency"><span><b><?php  if ($tot_debe>0) { echo $tot_debe;} ?></b></span></td>
			<td width="12.5%" align="right" class="td_currency"><span><b><?php  if ($tot_haber>0) {echo $tot_haber;} ?></b></span></td>
			<td width="12.5%" align="right" class="td_currency"><span><b><?php  if ($tot_debe_mb>0) {echo $tot_debe_mb;} ?></b></span></td>
			<td width="12.5%" align="right" class="td_currency"><span><b><?php  if ($tot_haber_mb>0) {echo $tot_haber_mb;} ?></b></span></td>
		
		<?php } ?>
	    </tr>
	
	
</tbody></table>
<br><br>

<table width="100%" cellspacing="0" cellpadding="0" border="1">
	<tbody><tr>		
		<td width="50%" class="td_label"><span>&nbsp;&nbsp;&nbsp;&nbsp;Elaborado por</span></td>		
		<td width="50%" class="td_label"><span>&nbsp;&nbsp;&nbsp;&nbsp;VoBo</span></td>
	</tr>
	<tr>
		<td width="50%" class="td_label"><br><br><br></td>
		<td width="50%" class="td_label"><br><br><br></td>
		
	</tr>
	<tr>
		<td width="50%" class="td_label"><span></span></td>
		<td width="50%" class="td_label"><span></span></td>
		
	</tr>
	<tr>
		<td width="50%" class="td_label"><span></span></td>
		<td width="50%" class="td_label"><span></span></td>
		
	</tr>
</tbody></table>

</body></html>