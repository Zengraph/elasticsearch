{*
 * Copyright (C) 2017-2018 thirty bees
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Academic Free License (AFL 3.0)
 * that is bundled with this package in the file LICENSE.md
 * It is also available through the world-wide-web at this URL:
 * http://opensource.org/licenses/afl-3.0.php
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to contact@thirtybees.com so we can send you a copy immediately.
 *
 * @author    thirty bees <contact@thirtybees.com>
 * @copyright 2017-2018 thirty bees
 * @license   http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
 *}
{* Components *}
{include file=ElasticSearch::tpl('hook/vue/results/stock-badge.vue.tpl')}
{* Template file *}
{capture name="template"}{include file=ElasticSearch::tpl('hook/vue/results/product-list-item.html.tpl')}{/capture}
<script type="text/javascript">
  (function () {
    Vue.component('product-list-item', {
      delimiters: ['%%', '%%'],
      template: "{$smarty.capture.template|escape:'javascript':'UTF-8'}",
      props: ['item', 'extraClass'],
      data: function () {
        return {
          idGroup: {$idGroup|intval},
          currencyConversion: {$currencyConversion|floatval}
        }
      },
      computed: {
        tax: function () {
          var taxes = {$taxes|json_encode};

          if (typeof this.item._source.{Elasticsearch::getAlias('id_tax_rules_group')|escape:'javascript':'UTF-8'} === 'undefined'
            || typeof taxes[this.item._source.{Elasticsearch::getAlias('id_tax_rules_group')|escape:'javascript':'UTF-8'}] === 'undefined') {
            return 1.000;
          }

          return 1  {*+ parseFloat(taxes[this.item._source.{Elasticsearch::getAlias('id_tax_rules_group')|escape:'javascript':'UTF-8'}]) / 100*};
        },
        basePriceTaxIncl: function () {
          return parseFloat(this.item._source.{Elasticsearch::getAlias('price_tax_excl')|escape:'javascript':'UTF-8'}_group_0) * this.tax * this.currencyConversion;
        },
        priceTaxIncl: function () {
          return parseFloat(this.item._source['{Elasticsearch::getAlias('price_tax_excl')|escape:'javascript':'UTF-8'}_group_' + this.idGroup]) * this.tax * this.currencyConversion;
        },
        discountPercentage: function () {
          percent = Math.round((1 - this.priceTaxIncl / this.basePriceTaxIncl) * 100);
		  if (percent=='12' || percent=='13') return '12.5';
		  if (this.idGroup=='28' && percent=='2') return '3';
		  if (this.idGroup=='32' && percent=='3') return '2';
		  else return percent;
        },
        layoutType: function () {
          return this.$store.state.layoutType;
        },
      },
      methods: {
        formatCurrency: function (price) {
          return window.formatCurrency(price, window.currencyFormat, window.currencySign, window.currencyBlank);
        },
      }
    });
  }());
</script>
