const path = require('path');
const glob = require('glob');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const PurifyCSSPlugin = require('purifycss-webpack');
const webpack = require('webpack');


module.exports = {
    cache: true,

    context: __dirname,

    entry: {
        'mitpe.certificate.style-ltr': './edx_credentials_themes/static/mitpe/sass/certificate-ltr.scss',
        'mitpe.certificate.style-rtl': './edx_credentials_themes/static/mitpe/sass/certificate-rtl.scss'
    },

    output: {
        path: path.resolve('./edx_credentials_themes/static/'),
        filename: '[name]-[hash].js'
    },

    plugins: [
        new ExtractTextPlugin('css/[name].css'),
        new PurifyCSSPlugin({
            minimize: true,
            verbose: true,
            paths: glob.sync(path.join(__dirname, 'edx_credentials_themes/templates/**/*.html'))
        })
    ],

    module: {
        rules: [
            {
                test: /\.s?css$/,
                use: ExtractTextPlugin.extract({
                    use: [
                        {
                            loader: 'css-loader'
                        },
                        {
                            loader: 'sass-loader'
                        }
                    ]
                })
            },
            {
                // TODO Make this work properly
                test: /\.woff2?$/,
                // Inline small woff files and output them below font
                loader: 'url-loader',
                query: {
                    name: 'font/[name].[ext]',
                    limit: 5000,
                    mimetype: 'application/font-woff'
                }
            },
            {
                test: /\.(ttf|eot|svg)$/,
                loader: 'file-loader',
                query: {
                    name: 'font/[name].[ext]'
                }
            }
        ]
    },
    resolve: {
        modules: ['./node_modules'],
        extensions: ['.css', '.scss']
    }
};
