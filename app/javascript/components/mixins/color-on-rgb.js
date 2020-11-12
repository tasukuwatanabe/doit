export default {
  methods: {
    colorOnRgb(hex) {
      if (hex.slice(0, 1) == "#") hex = hex.slice(1);
      if (hex.length == 3)
        hex =
          hex.slice(0, 1) +
          hex.slice(0, 1) +
          hex.slice(1, 2) +
          hex.slice(1, 2) +
          hex.slice(2, 3) +
          hex.slice(2, 3);

      const rgb = [hex.slice(0, 2), hex.slice(2, 4), hex.slice(4, 6)].map(
        function (labeltr) {
          return parseInt(labeltr, 16);
        }
      );

      const red = rgb[0],
        green = rgb[1],
        blue = rgb[2];

      if (red * 0.299 + green * 0.587 + blue * 0.114 < 186) {
        return "white";
      }
    }
  }
};
