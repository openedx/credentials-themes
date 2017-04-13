const path = require('path');
const glob = require('glob');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const PurifyCSSPlugin = require('purifycss-webpack');
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
            new ExtractTextPlugin('css/[name].css'),
            new PurifyCSSPlugin({
                minimize: false,
                verbose: true,
                paths: glob.sync(path.join(__dirname, `edx_credentials_themes/templates/${theme}/**/*.html`))
            })
        ],

        module: {
            rules: [
                {
                    test: /\.s?css$/,
                    use: ExtractTextPlugin.extract({
                        fallback: 'style-loader',
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