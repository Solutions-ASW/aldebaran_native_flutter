enum INVESTMENT { poupanca, cdi, carteira, celic }

// ignore: constant_identifier_names
const Map<INVESTMENT, double> PERCENT = {
  INVESTMENT.poupanca: 0.0031,
  INVESTMENT.cdi: 0.0043,
  INVESTMENT.carteira: 0.0,
  INVESTMENT.celic: 0.2,
};

Map<INVESTMENT, double> get getPorcent => PERCENT;
