const path = require('path');
const glob = require('glob');
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const webpack = require('webpack');


function generateConfig(theme) {
    let config = {
        cache: true,

        context: path.resolve(`./edx_credentials_themes/static/${theme}/`),

        entry: {},

        output: {
            path: path.resolve(`./edx_credentials_themes/static/${theme}/`),
            filename: '[name]-[hash].js'
        },

        plugins: [
            new MiniCssExtractPlugin({
                filename: 'css/[name].css'
            })
        ],

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
                          includePaths: [
                            path.join(__dirname, 'node_modules'),
                          ],
                        },
                      },
                    ]
                },
                {
                    test: /\.(ttf|otf|eot|svg|woff(2)?)(\?[a-z0-9]+)?$/,
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

    config.entry[`${theme}.certificate.style-ltr`] = './sass/certificate-ltr.scss';
    config.entry[`${theme}.certificate.style-rtl`] = './sass/certificate-rtl.scss';

    return config
}


let targets = ['mitpe'].map(generateConfig);
module.exports = targets;
