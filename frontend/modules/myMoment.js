import moment from 'moment';
import 'moment/locale/ja';

const formatMomentToString = datetime => datetime.format('YYYY-MM-DD').toLocaleString();

export { moment, formatMomentToString };
