const path = require('path');
const glob = require('glob');
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const webpack = require('webpack');

function generateBaseConfig(theme) {
  let config = {
    mode: 'production',
    cache: true,
    context: path.resolve(`./edx_credentials_themes/static/${theme}`),
    entry: {
      [`${theme}.base.style-ltr`]: './base/sass/main-ltr.scss',
      [`${theme}.base.style-rtl`]: './base/sass/main-rtl.scss',
      [`${theme}.certificate.style-ltr`]: './certificates/sass/certificate-ltr.scss',
      [`${theme}.certificate.style-rtl`]: './certificates/sass/certificate-rtl.scss',
    },
    plugins: [
      new MiniCssExtractPlugin({
        filename: 'css/[name].css'
      }),
    ],
    output: {
      path: path.resolve(`./edx_credentials_themes/static/${theme}/`),
    },
    stats: {
      errors: true,
      errorDetails: true,
    },
    optimization: {
      minimize: true,
    },
    module: {
      rules: [
        {
          test: /\.s?css$/,
          use: [
            'style-loader',
            MiniCssExtractPlugin.loader,
            'css-loader',
            {
              loader: 'sass-loader',
              options: {
                sassOptions: {
                  includePaths: [
                    path.join(__dirname, 'node_modules'),
                  ],
                },
              },
            },
          ]
        },
        {
          test: /\.woff2?$/,
          // Inline small woff files and output them below font
          use: [
              {
                loader: 'url-loader',
                options: {
                  name: 'fonts/[name]-[contenthash].[ext]',
                  limit: 5000,
                  mimetype: 'font/woff2',
                }
              }
          ]
        },
        {
          test: /\.(ttf|otf|eot|svg|)(\?[a-z0-9]+)?$/,
          use: [{
            loader: 'file-loader',
            options: {
              name: 'fonts/[name].[ext]',
              publicPath: '../'
            }
          }]

        }
      ]
    },
    resolve: {
      modules: ['./node_modules'],
      extensions: ['.css', '.js', '.scss']
    }
  };

  return config
}

// Change back to ['edx.org'].map(generateCertificateConfig) once we add in
// the need to style Program certificates
let targets = [];
let baseTargets = ['edx.org'].map(generateBaseConfig);
for (configIndex in baseTargets) {
  targets.push(baseTargets[configIndex]);
}
module.exports = targets;
