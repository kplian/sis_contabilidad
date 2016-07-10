<font size="9">
<table width="100%" cellpadding="5px"  rules="cols" border="1">
	
		<tr>
			<td width="70%"><b>Beneficiario:</b>&nbsp;&nbsp;&nbsp;&nbsp;  <?php  echo $this->cabecera[0]['beneficiario']; ?></td>
			<td width="30%"><b>Nro Trámite:</b>&nbsp;&nbsp;&nbsp;&nbsp;  <?php  echo $this->cabecera[0]['nro_tramite']; ?></td>
		</tr>
		
		<tr>
			<td><b>Glosa:</b>&nbsp;&nbsp;&nbsp;&nbsp; <?php  echo trim($this->cabecera[0]['glosa1']).'<br>'.trim($this->cabecera[0]['glosa2']); ?></td>
			 <?php 
			  if ($this->cabecera[0]['id_moneda'] != $this->cabecera[0]['id_moneda_base']){
			 ?>
		      <td><b>T/C:</b> &nbsp;&nbsp;&nbsp;&nbsp;<?php  echo $this->cabecera[0]['tipo_cambio']; ?></td>
		    <?php } ?>
		</tr>
		
		
		
</table>

<?php   
	if ($this->cabecera[0]['id_moneda'] == $this->cabecera[0]['id_moneda_base']){
		$with_col = '60%';
	}
	else{
		$with_col = '50%';
	}

?>

<table width="100%" cellpadding="5px"  rules="cols" border="1">
	<tbody>
		
		<?php 
		  if ($this->cabecera[0]['id_moneda'] == $this->cabecera[0]['id_moneda_base']){
		 ?>
		<tr>
			<td width="60%" rowspan="2" align="center" ><b>DETALLE</b></td>
			<td width="40%" colspan="2"  align="center" class="td_currency"><span><b><?php  echo $this->cabecera[0]['desc_moneda']; ?></b></span></td>
		</tr>
		<tr>
			<td width="20%" align="center" class="td_currency"><span><b>DEBE</b></span></td>
			<td width="20%" align="center" class="td_currency"><span><b>HABER</b></span></td>
		</tr>
<?php	}
		else{  ?>
		<tr>
			<td width="50%" rowspan="2" align="center" ><b>DETALLE</b></td>
			<td width="25%" colspan="2"  align="center" class="td_currency"><span><b><?php  echo $this->cabecera[0]['desc_moneda']; ?></b></span></td>
			<td width="25%" colspan="2"  align="center" class="td_currency"><span><b><?php  echo $this->cabecera[0]['codigo_moneda_base']; ?></b></span></td>
		
		</tr>
		<tr>
			<td width="12.5%" align="center" class="td_currency"><span><b>DEBE</b></span></td>
			<td width="12.5%" align="center" class="td_currency"><span><b>HABER</b></span></td>
			<td width="12.5%" align="center" class="td_currency"><span><b>DEBE</b></span></td>
			<td width="12.5%" align="center" class="td_currency"><span><b>HABER</b></span></td>
		</tr>
			
		<?php } ?>
		
		<?php 
		   $tot_debe = 0;
		   $tot_haber = 0;
		   foreach($this->detalleCbte as $key=>$val){     ?>
		<tr>
		    <td width="<?php  echo $with_col; ?>" ><div>
				<b>CC:</b> <?php  echo  $val['cc']; ?> 
			<?php if  ($val['codigo_partida']!=''){ ?>	
	   			<br/><b>Ptda.:</b> <?php  echo $val['codigo_partida'].'-'.$val['nombre_partida']; ?>
	   		<?php } ?>		
	   			<br/><b>Cta.:</b> <?php  echo $val['codigo_cuenta'].' - '.$val['nombre_cuenta']; ?>
	   		<?php if  ($val['codigo_auxiliar']!=''){ ?>	
	   			<br/><b>Aux.:</b> <?php  echo $val['codigo_auxiliar'].' - '.$val['nombre_auxiliar']; ?>
	   		<?php } ?>	
	   		
	   		<?php if  ($val['desc_orden']!=''){ ?>	
	   			<br/><b>OT.:</b> <?php  echo $val['desc_orden']; ?>
	   		<?php } ?>	
	   		    <br/><?php  echo trim($val['glosa']); ?></div>
			</td>
			
		<?php 
		  if ($this->cabecera[0]['id_moneda'] == $this->cabecera[0]['id_moneda_base']){
		 ?>
			
			<td width="20%" align="right" ><span><?php  if ($val['importe_debe']>0) {echo  number_format($val['importe_debe'], 2, '.', ',');} ?></span></td>
			<td width="20%" align="right" ><span><?php  if ($val['importe_haber']>0) {echo  number_format($val['importe_haber'], 2, '.', ',');} ?></span></td>
		<?php	
		  }
		 else{  
		?>
		    <td width="12.5%" align="right" ><span><?php  if ($val['importe_debe']>0) {echo   number_format($val['importe_debe'], 2, '.', ','); }?></span></td>
			<td width="12.5%" align="right" ><span><?php  if ($val['importe_haber']>0) {echo   number_format($val['importe_haber'], 2, '.', ',');} ?></span></td>
			<td width="12.5%" align="right" ><span><?php  if ($val['importe_debe_mb']>0) {echo   number_format($val['importe_debe_mb'], 2, '.', ',');} ?></span></td>
			<td width="12.5%" align="right" ><span><?php  if ($val['importe_haber_mb']>0) {echo   number_format($val['importe_haber_mb'], 2, '.', ',');} ?></span></td>
		
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
		  if ($this->cabecera[0]['id_moneda'] == $this->cabecera[0]['id_moneda_base']){
		 ?>
			
			<td width="20%" align="right" class="td_currency"><span><b><?php  if ($tot_debe>0) { echo number_format($tot_debe, 2, '.', ',');} ?></b></span></td>
			<td width="20%" align="right" class="td_currency"><span><b><?php  if ($tot_haber>0) {echo number_format($tot_haber, 2, '.', ',');} ?></b></span></td>
		<?php	
		  }
		 else{  
		?>
		    <td width="12.5%" align="right" ><span><b><?php  if ($tot_debe>0) { echo number_format($tot_debe, 2, '.', ',');} ?></b></span></td>
			<td width="12.5%" align="right" ><span><b><?php  if ($tot_haber>0) {echo number_format($tot_haber, 2, '.', ',');} ?></b></span></td>
			<td width="12.5%" align="right" ><span><b><?php  if ($tot_debe_mb>0) {echo number_format($tot_debe_mb, 2, '.', ',');} ?></b></span></td>
			<td width="12.5%" align="right" ><span><b><?php  if ($tot_haber_mb>0) {echo number_format($tot_haber_mb, 2, '.', ',');} ?></b></span></td>
		
		<?php } ?>
	    </tr>
	    <tr>		
		<td width="100%" class="td_label" align="right"><font size="7"><?php  echo $this->cabecera[0]['usr_reg']; ?>  (id: <?php  echo $this->cabecera[0]['id_int_comprobante']; ?>)</font></td>	
		</tr>
	
	
</tbody></table>

</font>