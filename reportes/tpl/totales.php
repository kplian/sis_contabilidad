<font size="8"><table width="100%" cellpadding="1px"  rules="cols" border="1">
<tr>
			<td width="<?php  echo $this->with_col; ?>" align="right"><b><?php  echo $titulo; ?>&nbsp;&nbsp;&nbsp;&nbsp;</b></td>	
		<?php 
		  if ($this->cabecera[0]['id_moneda'] == $this->cabecera[0]['id_moneda_base']){
		 ?>
			<td width="15%" align="right"><b>&nbsp;</b></td>
			<td width="15%" align="right" class="td_currency"><span><b><?php  if ($this->tot_debe>0) { echo number_format($this->tot_debe, 2, '.', ',');} ?></b></span></td>
			<td width="15%" align="right" class="td_currency"><span><b><?php  if ($this->tot_haber>0) {echo number_format($this->tot_haber, 2, '.', ',');} ?></b></span></td>
		<?php	
		  }
		 else{  
		?>
		    <td width="11%" align="right"><b>&nbsp;</b></td>
			<td width="11%" align="right" ><span><b><?php  if ($this->tot_debe>0) { echo number_format($this->tot_debe, 2, '.', ',');} ?></b></span></td>
			<td width="11%" align="right" ><span><b><?php  if ($this->tot_haber>0) {echo number_format($this->tot_haber, 2, '.', ',');} ?></b></span></td>
			<td width="11%" align="right" ><span><b><?php  if ($this->tot_debe_mb>0) {echo number_format($this->tot_debe_mb, 2, '.', ',');} ?></b></span></td>
			<td width="11%" align="right" ><span><b><?php  if ($this->tot_haber_mb>0) {echo number_format($this->tot_haber_mb, 2, '.', ',');} ?></b></span></td>
		
		<?php } ?>
	    </tr>
</table></font>