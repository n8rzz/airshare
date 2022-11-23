import {
  Accordion,
  Grid,
  Col,
  Container,
  Title,
} from '@mantine/core';
import { useFaqPageStyles } from './FaqPage.styles';

const placeholder =
  'It can’t help but hear a pin drop from over half a mile away, so it lives deep in the mountains where there aren’t many people or Pokémon.';

interface IProps {}

export const FaqPage: React.FC<IProps> = (props) => {
  const { classes } = useFaqPageStyles();

  return (
    <div className={classes.wrapper}>
      <Container size={'lg'}>
        <Grid gutter={50} id={'faq-grid'}>
          {/* <Col span={12} md={6}>
            <Image src={null} alt="Frequently Asked Questions" />
            Frequently Asked Questions
          </Col> */}
          <Col md={6} span={12}>
            <Title align={'left'} className={classes.title} order={2}>
              Frequently Asked Questions
            </Title>

            <Accordion
              chevronPosition={'right'}
              defaultValue={'reset-password'}
              variant={'separated'}
            >
              <Accordion.Item className={classes.item} value={'reset-password'}>
                <Accordion.Control>
                  How can I reset my password?
                </Accordion.Control>
                <Accordion.Panel>{placeholder}</Accordion.Panel>
              </Accordion.Item>

              <Accordion.Item className={classes.item} value={'another-account'}>
                <Accordion.Control>
                  Can I create more that one account?
                </Accordion.Control>
                <Accordion.Panel>{placeholder}</Accordion.Panel>
              </Accordion.Item>

              <Accordion.Item className={classes.item} value={'newsletter'}>
                <Accordion.Control>
                  How can I subscribe to monthly newsletter?
                </Accordion.Control>
                <Accordion.Panel>{placeholder}</Accordion.Panel>
              </Accordion.Item>

              <Accordion.Item className={classes.item} value={'credit-card'}>
                <Accordion.Control>
                  Do you store credit card information securely?
                </Accordion.Control>
                <Accordion.Panel>{placeholder}</Accordion.Panel>
              </Accordion.Item>

              <Accordion.Item className={classes.item} value={'payment'}>
                <Accordion.Control>
                  What payment systems to you work with?
                </Accordion.Control>
                <Accordion.Panel>{placeholder}</Accordion.Panel>
              </Accordion.Item>
            </Accordion>
          </Col>
        </Grid>
      </Container>
    </div>
  );
};
