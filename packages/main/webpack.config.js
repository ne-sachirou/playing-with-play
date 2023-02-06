"use strict";
import path from "path";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

export default {
  entry: "src/index.ts",
  rules: [
    {
      test: /\.ts$/,
      use: ["ts-loader"],
    },
  ],
  resolve: {
    extensions: [".js", '.ts', '.tsx'],
  },
  output: {
    filename: "index.js",
    path: path.resolve(__dirname, "dist"),
  },
};
